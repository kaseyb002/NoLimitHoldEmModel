import Foundation

public struct PlayerHand: Codable, Hashable {
    public var player: Player
    public let startingChipCount: Decimal
    public var hasMovedThisRound: Bool = false
    public var currentBet: Decimal = .zero
    public var status: Status
    public var showCards: ShowCards?
    public var isAllIn: Bool { player.chipCount  == .zero }
    
    public enum Status: String, Hashable, Codable {
        case `in`, `out`
    }
    
    public init(
        player: Player,
        hasMovedThisRound: Bool = false,
        currentBet: Decimal = .zero,
        showCards: ShowCards? = nil,
        status: Status = .in
    ) {
        self.startingChipCount = player.chipCount
        self.player = player
        self.hasMovedThisRound = hasMovedThisRound
        self.currentBet = currentBet
        self.showCards = showCards
        self.status = status
    }
}
