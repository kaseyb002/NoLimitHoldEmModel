import Foundation

extension NoLimitHoldEmHand.Log {
    public static func fake(
        handID: String = "8b5e3a1e-3c98-4216-a4e7-c72e263c02eb",
        started: Date = "2023-04-18".date(withFormat: "yyyy-MM-dd")!,
        startingPlayerHands: [PlayerHand] = [
            .fake(
                player: .fake(
                    id: "1",
                    name: "A"
                )
            ),
            .fake(
                player: .fake(
                    id: "2",
                    name: "B"
                )
            ),
            .fake(
                player: .fake(
                    id: "3",
                    name: "C"
                )
            ),
            .fake(
                player: .fake(
                    id: "4",
                    name: "D"
                )
            ),
        ],
        board: [Card] = [
            .init(rank: .ten, suit: .spade),
            .init(rank: .jack, suit: .spade),
            .init(rank: .queen, suit: .spade),
            .init(rank: .king, suit: .spade),
            .init(rank: .ace, suit: .spade),
        ],
        pocketCards: [String: PocketCards] = [
            "1": PocketCards(
                first: Card(rank: .ace, suit: .heart),
                second: Card(rank: .king, suit: .heart)
            ),
            "2": PocketCards(
                first: Card(rank: .ace, suit: .club),
                second: Card(rank: .king, suit: .club)
            ),
            "3": PocketCards(
                first: Card(rank: .ace, suit: .diamond),
                second: Card(rank: .king, suit: .diamond)
            ),
            "4": PocketCards(
                first: Card(rank: .queen, suit: .heart),
                second: Card(rank: .three, suit: .heart)
            ),
        ],
        blinds: Blinds = .init(25, 50),
        actions: NoLimitHoldEmHand.Log.Actions = .init(),
        results: NoLimitHoldEmHand.Log.Results? = nil
    ) -> NoLimitHoldEmHand.Log {
        .init(
            handID: handID,
            started: started,
            startingPlayerHands: startingPlayerHands,
            board: board,
            pocketCards: pocketCards,
            blinds: blinds
        )
    }
}
