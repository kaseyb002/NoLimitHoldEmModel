import Foundation

extension PokerHand {
    public enum Rank: Hashable, Codable {
        case highCard(HighCard)
        case onePair(Pair)
        case twoPair(TwoPair)
        case threeOfAKind(ThreeOfAKind)
        case straight(Straight)
        case flush(Flush)
        case fullHouse(FullHouse)
        case fourOfAKind(FourOfAKind)
        case straightFlush(StraightFlush)
        
        public var rankLevel: Int {
            switch self {
            case .highCard: return 0
            case .onePair: return 1
            case .twoPair: return 2
            case .threeOfAKind: return 3
            case .straight: return 4
            case .flush: return 5
            case .fullHouse: return 6
            case .fourOfAKind: return 7
            case .straightFlush: return 8
            }
        }
        
        public var displayName: String {
            switch self {
            case .highCard(let highCard):
                return "\(highCard.cards.max(by: { $0.rank > $1.rank })!.rank.longDisplayValue) High"
            case .onePair: return "Pair"
            case .twoPair: return "Two Pair"
            case .threeOfAKind: return "Three of a Kind"
            case .straight: return "Straight"
            case .flush: return "Flush"
            case .fullHouse: return "Full House"
            case .fourOfAKind: return "Four of a Kind"
            case .straightFlush: return "Straight Flush"
            }
        }
        
        public static func > (lhs: PokerHand.Rank, rhs: PokerHand.Rank) -> Bool? {
            if lhs.rankLevel > rhs.rankLevel {
                return true
            }
            
            if lhs.rankLevel < rhs.rankLevel {
                return false
            }
            
            // Tie-breaking
            switch (lhs, rhs) {
            case let (.highCard(lhsHighCard), .highCard(rhsHighCard)):
                return lhsHighCard.cards > rhsHighCard.cards
            
            case let (.onePair(lhsPair), .onePair(rhsPair)):
                if let isGreater: Bool = lhsPair.pairCard > rhsPair.pairCard {
                    return isGreater
                } else {
                    return lhsPair.remainder > rhsPair.remainder
                }
            
            case let (.twoPair(lhsTwoPair), .twoPair(rhsTwoPair)):
                if let isGreater: Bool = lhsTwoPair.higher > rhsTwoPair.higher {
                    return isGreater
                } else if let isGreater: Bool = lhsTwoPair.lower > rhsTwoPair.lower {
                    return isGreater
                } else {
                    return [lhsTwoPair.remainder] > [rhsTwoPair.remainder]
                }
                
            case let (.threeOfAKind(lhsThreeOfAKind), .threeOfAKind(rhsThreeOfAKind)):
                if let isGreater: Bool = lhsThreeOfAKind.threeOfAKind > rhsThreeOfAKind.threeOfAKind {
                    return isGreater
                } else {
                    return lhsThreeOfAKind.remainder > rhsThreeOfAKind.remainder
                }
            
            case let (.straight(lhsStraight), .straight(rhsStraight)):
                return lhsStraight.highCard > rhsStraight.highCard
                
            case let (.flush(lhsFlush), .flush(rhsFlush)):
                return lhsFlush.cards > rhsFlush.cards
            
            case let (.fullHouse(lhsHouse), .fullHouse(rhsHouse)):
                if let isGreater: Bool = lhsHouse.threeOfAKind > rhsHouse.threeOfAKind {
                    return isGreater
                } else {
                    return lhsHouse.remainingPair > rhsHouse.remainingPair
                }
                
            case let (.fourOfAKind(lhsFourOfAKind), .fourOfAKind(rhsFourOfAKind)):
                if let isGreater: Bool = lhsFourOfAKind.fourOfAKind > rhsFourOfAKind.fourOfAKind {
                    return isGreater
                } else {
                    return lhsFourOfAKind.remainder > rhsFourOfAKind.remainder
                }
            
            case let (.straightFlush(lhsStraightFlush), .straightFlush(rhsStraightFlush)):
                return lhsStraightFlush.highCard > rhsStraightFlush.highCard
                        
            default:
                return nil
            }
        }
    }
}
