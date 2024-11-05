import Foundation

public struct PocketCards: Hashable, Codable {
    public let first: Card
    public let second: Card
    public var cards: [Card] { [first, second] }
    
    public init(
        first: Card,
        second: Card
    ) {
        self.first = first
        self.second = second
    }
}
