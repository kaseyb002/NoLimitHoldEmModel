import Foundation

public struct Deck: Hashable, Codable, Sendable {
    public var cards: [Card]
    
    public mutating func shuffle() {
        cards.shuffle()
    }
    
    public init() {
        var cards: [Card] = []
        for suit in Card.Suit.allCases {
            for rank in Card.Rank.allCases {
                let card: Card = .init(
                    rank: rank,
                    suit: suit
                )
                cards.append(card)
            }
        }
        self.cards = cards
    }
    
    public init(cards: [Card]) {
        self.cards = cards
    }
}
