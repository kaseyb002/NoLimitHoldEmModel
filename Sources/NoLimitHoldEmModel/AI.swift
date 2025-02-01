import Foundation

public final class AI {
    public static func makeAIMoveIfNeeded(
        in hand: NoLimitHoldEmHand,
        autoAdvance: Bool
    ) -> NoLimitHoldEmHand {
        var updatedHand: NoLimitHoldEmHand = hand
        updatedHand.makeAIMoveIfNeeded(autoAdvance: autoAdvance)
        return updatedHand
    }
}

private extension NoLimitHoldEmHand {
    mutating func makeAIMoveIfNeeded(autoAdvance: Bool) {
        guard state != .handComplete,
              let currentPlayerHand,
              currentPlayerHand.isAllIn == false
        else {
            return
        }
        
        switch round {
        case .preflop:
            makeMove(preflopMove())
            
        case .flop, .turn, .river:
            if let currentPlayersBestHand {
                makeMove(postflopMove(bestHand: currentPlayersBestHand))
            } else {
                makeBlindMove()
            }
        }
        
        if autoAdvance {
            makeAIMoveIfNeeded(autoAdvance: autoAdvance)
        }
    }
    
    private mutating func makeBlindMove() {
        do {
            switch Int.random(in: 1...100) {
            case 1...30:
                try check()
                
            case 31...50:
                try bet(amount: minBetForCurrentPlayer)
                
            case 51...85:
                try fold()
                
            case 86...98:
                try bet(amount: blinds.bigBlind * 3)
            
            default:
                try bet(amount: maxBetForCurrentPlayer)
            }
        } catch {
            makeBlindMove()
        }
    }
    
    private mutating func makeMove(_ aiMove: AIMove) {
        guard let currentPlayerHand else { return }
        do {
            switch aiMove {
            case .check:
                try check()
                
            case .call:
                try call()
                
            case .raise3xBlind:
                try bet(amount: blinds.bigBlind * 3)
                
            case .raisePot:
                try bet(amount: maxOutstandingBet * 3)
                
            case .allIn:
                try bet(amount: currentPlayerHand.player.chipCount)
                
            case .fold:
                try fold()
            }
        } catch {
            makeBlindMove()
        }
    }
    
    private func preflopMove() -> AIMove {
        guard let currentPlayerHand else { return .fold }
        if isFacingNoBet {
            switch currentPlayerHand.pocketCards.tier {
            case 1, 2, 3:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.90)) ? .raise3xBlind : .call
                
            case 4, 5:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.50)) ? .raise3xBlind : .call
                
            default:
                if justNeedToPaySmallBlind {
                    return .call
                } else if BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.75)) {
                    return .fold
                } else {
                    return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.85)) ? .call : .raise3xBlind
                }
            }
        } else if isFacingStandardBet {
            switch currentPlayerHand.pocketCards.tier {
            case 1, 2:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.80)) ? .raisePot : .call
                
            case 3, 4, 5:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.15)) ? .raisePot : .call
                
            default:
                if BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.85)) {
                    return .fold
                } else {
                    return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.85)) ? .call : .raise3xBlind
                }
            }
        } else if isFacingBigBet {
            switch currentPlayerHand.pocketCards.tier {
            case 1, 2:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.80)) ? .raisePot : .call
                
            case 3, 4, 5:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.80)) ? .call : .fold
                
            default:
                if BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.95)) {
                    return .fold
                } else {
                    return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.90)) ? .call : .raisePot
                }
            }
        } else {
            return .fold
        }
    }
    
    private func postflopMove(bestHand: PokerHand) -> AIMove {
        if isFacingNoBet {
            switch bestHand.tier {
            case 1, 2, 3:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.90)) ? .raise3xBlind : .call
                
            case 4, 5:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.50)) ? .raise3xBlind : .call
                
            default:
                if justNeedToPaySmallBlind {
                    return .call
                } else if BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.75)) {
                    return .fold
                } else {
                    return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.85)) ? .call : .raise3xBlind
                }
            }
        } else if isFacingStandardBet {
            switch bestHand.tier {
            case 1, 2:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.80)) ? .raisePot : .call
                
            case 3, 4, 5:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.15)) ? .raisePot : .call
                
            default:
                if BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.85)) {
                    return .fold
                } else {
                    return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.85)) ? .call : .raise3xBlind
                }
            }
        } else if isFacingBigBet {
            switch bestHand.tier {
            case 1, 2:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.80)) ? .raisePot : .call
                
            case 3, 4, 5:
                return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.80)) ? .call : .fold
                
            default:
                if BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.95)) {
                    return .fold
                } else {
                    return BoolExtensions.random(withProbability: probabilityWeightedByPlayerCount(baseProbability: 0.90)) ? .call : .raisePot
                }
            }
        } else {
            return .fold
        }
    }
    
    private func probabilityWeightedByPlayerCount(baseProbability: Float) -> Float {
        func weight(by amount: Float) -> Float {
            (baseProbability + amount) / (1 + amount)
        }
        
        switch playerHands.count {
        case 0 ... 3:
            return weight(by: 2)
            
        case 4 ... 7:
            return weight(by: 1)
            
        default:
            return baseProbability
        }
    }
    
    private var justNeedToPaySmallBlind: Bool {
        guard let currentPlayerHand else { return false }
        return maxOutstandingBet == blinds.bigBlind && currentPlayerHand.currentBet == blinds.smallBlind
    }
    
    private var isFacingNoBet: Bool {
        maxOutstandingBet <= blinds.bigBlind
    }
    
    private var isFacingStandardBet: Bool {
        guard isFacingNoBet == false else {
            return false
        }
        return maxOutstandingBet <= blinds.bigBlind * 3
    }
    
    private var isFacingBigBet: Bool {
        maxOutstandingBet > blinds.bigBlind * 3
    }
    
    private var currentPlayersBestHand: PokerHand? {
        guard let currentPlayerHand else { return nil }
        switch round {
        case .preflop:
            return nil
            
        case .flop:
            return try? .init(
                cards: [
                    currentPlayerHand.pocketCards.first,
                    currentPlayerHand.pocketCards.second,
                ] + board[0...2]
            )
            
        case .turn:
            return try? .init(
                cards: [
                    currentPlayerHand.pocketCards.first,
                    currentPlayerHand.pocketCards.second,
                ] + board[0...3]
            )
            
        case .river:
            return try? .init(
                cards: [
                    currentPlayerHand.pocketCards.first,
                    currentPlayerHand.pocketCards.second,
                ] + board[0...4]
            )
        }
    }
}

enum AIMove {
    case check
    case call
    case raise3xBlind
    case raisePot
    case allIn
    case fold
}

private extension PokerHand {
    var tier: Int {
        switch topRank {
        case .highCard:
            return 6
            
        case .onePair:
            return 5
            
        case .twoPair:
            return 4
            
        case .threeOfAKind:
            return 3
            
        case .flush, .straight:
            return 2
            
        case .straightFlush, .fourOfAKind, .fullHouse:
            return 1
        }
    }
}

extension PocketCards {
    public var tier: Int? {
        // Tier 1
        if isPocketPair(rank: .ace) {
            return 1
        }
        
        if isPocketPair(rank: .king) {
            return 1
        }
        
        if hasRanks(.ace, and: .king) && isSuited {
            return 1
        }
        
        // Tier 2
        if isPocketPair(rank: .queen) {
            return 2
        }
        
        if hasRanks(.ace, and: .king) {
            return 2
        }
        
        if isPocketPair(rank: .jack) {
            return 2
        }
        
        if isPocketPair(rank: .ten) {
            return 2
        }
        
        // Tier 3
        if hasRanks(.ace, and: .queen) {
            return 3
        }
        
        if isPocketPair(rank: .nine) {
            return 3
        }
        
        if isPocketPair(rank: .eight) {
            return 3
        }
        
        if hasRanks(.ace, and: .jack) && isSuited {
            return 3
        }
        
        // Tier 4
        if isPocketPair(rank: .seven) {
            return 4
        }
        
        if hasRanks(.king, and: .queen) && isSuited {
            return 4
        }
        
        if isPocketPair(rank: .six) {
            return 4
        }
        
        if hasRanks(.ace, and: .ten) && isSuited {
            return 4
        }
        
        if isPocketPair(rank: .five) {
            return 4
        }
        
        if hasRanks(.ace, and: .jack) {
            return 4
        }
        
        // Tier 5
        if hasRanks(.king, and: .queen) {
            return 5
        }
        
        if isPocketPair(rank: .four) {
            return 5
        }
        
        if hasRanks(.king, and: .jack) && isSuited {
            return 5
        }
        
        if isPocketPair(rank: .three) {
            return 5
        }
        
        if isPocketPair(rank: .two) {
            return 5
        }
        
        if hasRanks(.ace, and: .ten) {
            return 5
        }
        
        if hasRanks(.queen, and: .jack) && isSuited {
            return 5
        }
        
        return nil
    }
}
