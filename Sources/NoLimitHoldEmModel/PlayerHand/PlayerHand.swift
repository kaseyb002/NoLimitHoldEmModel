import Foundation

public struct PlayerHand: Codable, Hashable {
    public var player: Player
    public let pocketCards: PocketCards
    public let startingChipCount: Decimal
    public var hasMovedThisRound: Bool = false
    public var currentBet: Decimal = .zero
    public var status: Status
    public var isAllIn: Bool { player.chipCount  == .zero }
    
    public enum Status: String, Hashable, Codable {
        case `in`, `out`
    }
    
    public init(
        pocketCards: PocketCards,
        player: Player,
        hasMovedThisRound: Bool = false,
        currentBet: Decimal = .zero,
        status: Status = .in
    ) {
        self.pocketCards = pocketCards
        self.startingChipCount = player.chipCount
        self.player = player
        self.hasMovedThisRound = hasMovedThisRound
        self.currentBet = currentBet
        self.status = status
    }
}
