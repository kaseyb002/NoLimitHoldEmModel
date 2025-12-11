import Foundation

public struct RevealedCards: Hashable, Codable, Sendable {
    public let first: Card?
    public let second: Card?
    public var cards: [Card] { [first, second].compactMap(\.self) }
    public var showingCards: ShowCards? {
        switch (first, second) {
        case (nil, nil):
            nil
            
        case (.some, nil):
            .first
            
        case (nil, .some):
            .second
            
        case (.some, .some):
            .both
        }
    }
    
    public init(
        first: Card? = nil,
        second: Card? = nil
    ) {
        self.first = first
        self.second = second
    }
}
