import Foundation

public struct Card: Hashable, Identifiable, Codable {
    public let rank: Rank
    public let suit: Suit
    
    public var id: String { rank.id + suit.id }
    
    public var debugDescription: String {
        "\(rank.displayValue)\(suit.emoji)"
    }
    
    public var imageAssetName: String {
        id.uppercased()
    }
    
    public init(
        rank: Rank,
        suit: Suit
    ) {
        self.rank = rank
        self.suit = suit
    }
    
    public init?(id: String) {
        guard let rankChar: Character = id.first,
              let rank: Rank = .init(rawValue: String(rankChar).lowercased()),
              let suitChar: Character = id.last,
              let suit: Suit = .init(rawValue: String(suitChar).lowercased())
        else {
            return nil
        }
        self.rank = rank
        self.suit = suit
    }
    
    public static func > (lhs: Card, rhs: Card) -> Bool? {
        if lhs.rank > rhs.rank {
            return true
        } else if lhs.rank < rhs.rank {
            return false
        }
        
        return nil
    }
}
