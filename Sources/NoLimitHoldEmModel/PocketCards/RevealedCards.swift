import Foundation

public struct RevealedCards: Hashable, Codable {
    public let first: Card?
    public let second: Card?
    public var cards: [Card] { [first, second].compactMap(\.self) }
    
    public init(
        first: Card? = nil,
        second: Card? = nil
    ) {
        self.first = first
        self.second = second
    }
}
