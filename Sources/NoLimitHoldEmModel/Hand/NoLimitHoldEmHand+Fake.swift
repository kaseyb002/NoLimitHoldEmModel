import Foundation

extension NoLimitHoldEmHand {
    public static func fake(
        blinds: Blinds = .init(
            smallBlind: .init(integerLiteral: 25),
            bigBlind: .init(integerLiteral: 50)
        ),
        players: [Player] = [
            .fake(id: "1", name: "Al", chipCount: 1500),
            .fake(id: "2", name: "Bob", chipCount: 1500),
            .fake(id: "3", name: "Cat", chipCount: 1500),
            .fake(id: "4", name: "Dave", chipCount: 1500),
            .fake(id: "5", name: "Ed", chipCount: 1500),
            .fake(id: "6", name: "Fred", chipCount: 1500),
            .fake(id: "7", name: "George", chipCount: 1500),
            .fake(id: "8", name: "Harry", chipCount: 1500),
            .fake(id: "9", name: "Ivan", chipCount: 1500),
            .fake(id: "10", name: "John", chipCount: 1500),
        ],
        deck: Deck? = .fake()
    ) throws -> NoLimitHoldEmHand {
        try .init(
            blinds: blinds,
            players: players,
            cookedDeck: deck
        )
    }
    
    public static func fakeForSidePot(
        blinds: Blinds = .init(
            smallBlind: .init(integerLiteral: 25),
            bigBlind: .init(integerLiteral: 50)
        ),
        players: [Player] = [
            .fake(id: "1", name: "Al", chipCount: .init(integerLiteral: 200)),
            .fake(id: "2", name: "Bob", chipCount: .init(integerLiteral: 500)),
            .fake(id: "3", name: "Cat", chipCount: .init(integerLiteral: 1000)),
            .fake(id: "4", name: "Dave", chipCount: .init(integerLiteral: 1500)),
            .fake(id: "5", name: "Ed", chipCount: .init(integerLiteral: 2000)),
        ],
        deck: Deck? = .fake()
    ) throws -> NoLimitHoldEmHand {
        try .init(
            blinds: blinds,
            players: players,
            cookedDeck: deck
        )
    }
    
    public static func randomizedFake(
        blinds: Blinds = [
            .init(
                smallBlind: .init(integerLiteral: 25),
                bigBlind: .init(integerLiteral: 50)
            )
        ].randomElement()!,
        players: [Player] = [
            .fake(),
            .fake(),
            .fake(),
            .fake(),
            .fake(),
            .fake(),
            .fake(),
            .fake(),
            .fake(),
            .fake(),
        ],
        deck: Deck? = nil
    ) throws -> NoLimitHoldEmHand {
        try .init(
            blinds: blinds,
            players: players.filter({ $0.chipCount > .zero }),
            cookedDeck: nil
        )
    }
}
