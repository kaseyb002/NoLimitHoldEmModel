import Foundation

public struct PlayerHand: Codable, Hashable, Sendable {
    public var player: Player
    public let startingChipCount: Decimal
    public var hasMovedThisRound: Bool = false
    public var currentBet: Decimal = .zero
    public var status: Status
    public var revealedCards: RevealedCards
    public var isAllIn: Bool { player.chipCount  == .zero }
    
    public enum Status: String, Hashable, Codable, Sendable {
        case `in`, `out`
    }
    
    public init(
        player: Player,
        hasMovedThisRound: Bool = false,
        currentBet: Decimal = .zero,
        revealedCards: RevealedCards = RevealedCards(),
        status: Status = .in
    ) {
        self.revealedCards = revealedCards
        self.startingChipCount = player.chipCount
        self.player = player
        self.hasMovedThisRound = hasMovedThisRound
        self.currentBet = currentBet
        self.status = status
    }
}
