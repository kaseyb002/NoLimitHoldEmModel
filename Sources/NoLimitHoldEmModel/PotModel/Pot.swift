import Foundation

public struct Pot: Hashable, Identifiable, Codable {
    public let id: String
    public var amount: Decimal
    public var isFull: Bool = false
    /// IDs of players who contributed to this pot
    public let playerIds: Set<String>
    
    public init(
        id: String = UUID().uuidString,
        amount: Decimal = .zero,
        playerIds: Set<String>,
        isFull: Bool = false
    ) {
        self.id = id
        self.amount = amount
        self.playerIds = playerIds
        self.isFull = isFull
    }
}

