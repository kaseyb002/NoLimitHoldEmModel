import Foundation

extension Card {
    public enum Rank: String, Hashable, Identifiable, CaseIterable, Codable {
        case ace = "a"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case ten = "t"
        case jack = "j"
        case queen = "q"
        case king = "k"
        
        public var id: String { rawValue }
        
        public var displayValue: String {
            switch self {
            case .ace: return "A"
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            case .five: return "5"
            case .six: return "6"
            case .seven: return "7"
            case .eight: return "8"
            case .nine: return "9"
            case .ten: return "10"
            case .jack: return "J"
            case .queen: return "Q"
            case .king: return "K"
            }
        }
        
        /// Indicates most valuable
        public var value: Int {
            switch self {
            case .ace: return 12
            case .two: return 0
            case .three: return 1
            case .four: return 2
            case .five: return 3
            case .six: return 4
            case .seven: return 5
            case .eight: return 6
            case .nine: return 7
            case .ten: return 8
            case .jack: return 9
            case .queen: return 10
            case .king: return 11
            }
        }
    }
}

extension Card.Rank: Comparable {
    public static func < (lhs: Card.Rank, rhs: Card.Rank) -> Bool {
        lhs.value < rhs.value
    }
}
