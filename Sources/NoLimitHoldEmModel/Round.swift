import Foundation

extension NoLimitHoldEmHand {
    public enum Round: Int, Hashable, Comparable, Codable, Sendable {
        case preflop
        case flop
        case turn
        case river
        
        public static func < (lhs: Round, rhs: Round) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}
