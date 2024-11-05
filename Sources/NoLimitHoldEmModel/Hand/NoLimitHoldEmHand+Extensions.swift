import Foundation

extension NoLimitHoldEmHand {
    public var totalCollectedPot: Decimal {
        pots.map { $0.amount }.reduce(.zero, +)
    }
    
    public var canCheck: Bool {
        (currentPlayerHand?.currentBet ?? .zero) >= maxOutstandingBet
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
        
        let amountToCall: Decimal = maxOutstandingBet - currentPlayerHand.currentBet
        if currentPlayerHand.player.chipCount < amountToCall {
            return currentPlayerHand.player.chipCount
        }
        
        return amountToCall
    }
    
    public var minRaiseForCurrentPlayer: Decimal {
        guard let currentPlayerHand else {
            return .zero
        }
        let minRaise: Decimal = maxOutstandingBet * 2
        if currentPlayerHand.player.chipCount < minRaise {
            return currentPlayerHand.player.chipCount
        }
        return minRaise
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
        return maxOutstandingBet > .zero && currentPlayerHand.currentBet <= maxOutstandingBet
    }
    
    public func isCurrentPlayerAndCanBet(playerID: String) -> Bool {
        guard let currentPlayerHand: PlayerHand,
              currentPlayerHand.player.id == playerID
        else {
            return false
        }
        return currentPlayerHand.player.chipCount > maxOutstandingBet
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
