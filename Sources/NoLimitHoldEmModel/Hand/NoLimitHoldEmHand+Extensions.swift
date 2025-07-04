import Foundation

extension NoLimitHoldEmHand {
    public var totalCollectedPot: Decimal {
        pots.map { $0.amount }.reduce(.zero, +)
    }
    
    public var canCheck: Bool {
        guard state.isWaitingForPlayerToAct else {
            return false
        }
        return (currentPlayerHand?.currentBet ?? .zero) >= maxOutstandingBet
    }
    
    public var totalPotAndBets: Decimal {
        totalCollectedPot + playerHands.map { $0.currentBet }.reduce(.zero, +)
    }
    
    public var currentPlayerHandIndex: Int? {
        switch state {
        case .waitingForSmallBlind:
            return 0
            
        case .waitingForBigBlind:
            return 1
            
        case .waitingForPlayerToAct(let playerIndex):
            return playerIndex
            
        case .waitingToProgressToNextRound, .handComplete:
            return nil
        }
    }
    
    public var currentPlayerHand: PlayerHand? {
        guard let currentPlayerHandIndex else {
            return nil
        }
        return playerHands[currentPlayerHandIndex]
    }
    
    public var activePlayerHands: [PlayerHand] {
        playerHands.filter({ $0.status == .in })
    }
    
    public var allInPlayerHands: [PlayerHand] {
        playerHands.filter({ $0.isAllIn })
    }
    
    public var maxOutstandingBet: Decimal {
        playerHands.map { $0.currentBet }.max()!
    }
    
    public var minBetForCurrentPlayer: Decimal {
        guard let currentPlayerHand else {
            return .zero
        }
        if currentPlayerHand.player.chipCount < blinds.bigBlind {
            return currentPlayerHand.player.chipCount
        }
        
        if maxOutstandingBet == .zero {
            return blinds.bigBlind
        }
        
        let amountToCall: Decimal = max(maxOutstandingBet, blinds.bigBlind) - currentPlayerHand.currentBet
        if currentPlayerHand.player.chipCount < amountToCall {
            return currentPlayerHand.player.chipCount
        }
        
        return amountToCall
    }
    
    public var minRaiseForCurrentPlayer: Decimal {
        guard let currentPlayerHand else {
            return .zero
        }
        var minRaise: Decimal = maxOutstandingBet
        let previousRaise: Decimal = max(
            allBets.sorted(by: >).first ?? .zero,
            blinds.bigBlind
        )
        minRaise += previousRaise
        minRaise -= currentPlayerHand.currentBet
        return min(
            minRaise,
            currentPlayerHand.player.chipCount
        )
    }
    
    private var allBets: [Decimal] {
        playerHands.map { $0.currentBet }
    }
    
    public var maxBetForCurrentPlayer: Decimal {
        currentPlayerHand?.player.chipCount ?? .zero
    }
    
    public enum Position: Equatable {
        case early, middle, late
    }
    
    public var currentPosition: Position? {
        guard let currentPlayerHandIndex else {
            return nil
        }
        
        if playerHands.count == 2 {
            return .late
        }
        
        switch playerHands.count - currentPlayerHandIndex {
        case 0, 1, 2, 3:
            return .late
            
        case 4, 5, 6:
            return .middle
            
        default:
            return .early
        }
    }
    
    public var dealerIndex: Int {
        if playerHands.count <= 2 {
            .zero
        } else {
            playerHands.count - 1
        }
    }
    
    public var dealer: PlayerHand {
        playerHands[dealerIndex]
    }
    
    public var bigBlindIndex: Int { 1 }
    
    public var bigBlind: PlayerHand {
        playerHands[bigBlindIndex]
    }
    
    public var smallBlindIndex: Int { 0 }
    
    public var smallBlind: PlayerHand {
        playerHands[smallBlindIndex]
    }
    
    public func hasChecked(playerID: String) -> Bool {
        guard let playerHand: PlayerHand = playerHand(byID: playerID) else {
            return false
        }
        
        return maxOutstandingBet == .zero && playerHand.currentBet == .zero && playerHand.hasMovedThisRound
    }
    
    public func isCurrentPlayerAndCanCheck(playerID: String) -> Bool {
        guard let currentPlayerHand: PlayerHand,
              currentPlayerHand.player.id == playerID
        else {
            return false
        }
        return currentPlayerHand.currentBet == maxOutstandingBet
    }

    public func isCurrentPlayerAndCanFold(playerID: String) -> Bool {
        guard let currentPlayerHand: PlayerHand,
              currentPlayerHand.player.id == playerID
        else {
            return false
        }
        return currentPlayerHand.currentBet < maxOutstandingBet
    }
    
    /// Not necessarily whether the player can match the bet, just if the player
    /// has the option of calling regardless of chip amount
    public func isCurrentPlayerAndCanCall(playerID: String) -> Bool {
        guard let currentPlayerHand: PlayerHand,
              currentPlayerHand.player.id == playerID
        else {
            return false
        }
        return maxOutstandingBet > .zero && currentPlayerHand.currentBet < maxOutstandingBet
    }
    
    public func isCurrentPlayerAndCanBet(playerID: String) -> Bool {
        guard let currentPlayerHand: PlayerHand,
              currentPlayerHand.player.id == playerID
        else {
            return false
        }
        return currentPlayerHand.player.chipCount > maxOutstandingBet - currentPlayerHand.currentBet
    }
    
    public var isReadyForDramaticReveal: Bool {
        guard round < .river,
              state == .waitingToProgressToNextRound
        else {
            return false
        }
        return activePlayersNotAllInCount <= 1 && activePlayerHands.count > 1
    }
    
    public var activePlayersNotAllInCount: Int {
        activePlayerHands
            .filter { $0.isAllIn == false }
            .count
    }
    
    public var forceRevealCardsForPlayerIDs: Set<String> {
        func forceRevealCards(playerHand: PlayerHand) -> Bool {
            guard playerHand.status == .in else {
                return false
            }
            
            if isReadyForDramaticReveal {
                return true
            }
            
            guard state == .handComplete else {
                return false
            }
            
            return activePlayerHands.count > 1
        }
        
        return activePlayerHands
            .filter(forceRevealCards)
            .map(\.player.id)
            .asSet()
    }
    
    public func drawTips(for playerID: String) -> String? {
        // Skip if hand isn't beyond preflop or if we're already on the river
        guard round != .preflop, round != .river,
              let pocket = pocketCards[playerID] else {
            return nil
        }

        let allCards = board + pocket.cards
        let suits = Dictionary(grouping: allCards, by: { $0.suit })
        let flushDrawSuit = suits.first(where: { $0.value.count == 4 })?.key

        var tips: [String] = []

        // Flush draw: 4 cards of the same suit
        if let suit = flushDrawSuit {
            tips.append("One more \(suit.emoji) gives you a Flush.")
        }

        // Straight draw logic
        let ranks: Set<Int> = Set(allCards.map { $0.rank.value })
        let possibleDraws: [[Int]] = [
            [0, 1, 2, 3],
            [1, 2, 3, 4],
            [2, 3, 4, 5],
            [3, 4, 5, 6],
            [4, 5, 6, 7],
            [5, 6, 7, 8],
            [6, 7, 8, 9],
            [7, 8, 9, 10],
            [8, 9, 10, 11],
            [9, 10, 11, 12],
            [0, 9, 10, 11], // Weird edge cases (if you want to allow it)
            [0, 1, 2, 12]   // A234 wheel draw
        ]

        for draw in possibleDraws {
            let missing = draw.filter { !ranks.contains($0) }
            if missing.count == 1 {
                if let rank = Card.Rank.allCases.first(where: { $0.value == missing[0] }) {
                    tips.append("\(rank.displayValue) gives you a Straight.")
                }
            }
        }

        return tips.isEmpty ? nil : tips.joined(separator: " ")
    }
}

// MARK: - Player Hand Accessors
extension NoLimitHoldEmHand {
    internal func index(byPlayerId playerId: String) -> Int? {
        playerHands.firstIndex(where: { $0.player.id == playerId })
    }
    
    public func playerHand(byID playerID: String) -> PlayerHand? {
        playerHands.first(where: { playerID == $0.player.id })
    }
}


extension NoLimitHoldEmHand.State {
    public var isWaitingForPlayerToAct: Bool {
        switch self {
        case .waitingForSmallBlind,
                .waitingForBigBlind,
                .waitingToProgressToNextRound,
                .handComplete
            :
            false
            
        case .waitingForPlayerToAct:
            true
        }
    }
}
