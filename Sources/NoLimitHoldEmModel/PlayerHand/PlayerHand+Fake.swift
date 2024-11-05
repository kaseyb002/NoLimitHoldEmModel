import Foundation

extension PlayerHand {
    public static func fake(
        pocketCards: PocketCards = .fake(),
        player: Player = .fake(),
        currentBet: Decimal = .init(integerLiteral: Bool.random() ? .zero : .random(in: 1...12) * 25),
        status: Status = Bool.random() ? .in : .out
    ) -> PlayerHand {
        var validStatus: Status = status
        if player.chipCount == .zero {
            validStatus = .out
        }
        return .init(
            pocketCards: pocketCards,
            player: player,
            currentBet: validStatus == .out ? .zero : currentBet,
            status: validStatus
        )
    }
}
