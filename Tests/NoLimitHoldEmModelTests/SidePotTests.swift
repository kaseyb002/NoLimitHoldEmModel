import Testing
@testable import NoLimitHoldEmModel

struct SidePotTests {

    @Test func allInSidePots() async throws {
        let deck: Deck = .sidePot5()
        var hand: NoLimitHoldEmHand = try .init(
            blinds: .init(
                0.25,
                0.50
            ),
            players: [
                .init(
                    id: "2",
                    name: "Cara",
                    chipCount: 13.27,
                    imageURL: nil
                ),
                .init(
                    id: "3",
                    name: "Nolan",
                    chipCount: 36.03,
                    imageURL: nil
                ),
                .init(
                    id: "1",
                    name: "Me",
                    chipCount: 11.27,
                    imageURL: nil
                ),
                .init(
                    id: "4",
                    name: "Tonia",
                    chipCount: 22.12,
                    imageURL: nil
                ),
                .init(
                    id: "5",
                    name: "Reid",
                    chipCount: 59.72,
                    imageURL: nil
                ),
                .init(
                    id: "6",
                    name: "Hudson",
                    chipCount: 50.41,
                    imageURL: nil
                ),
                .init(
                    id: "7",
                    name: "Shirley",
                    chipCount: 65.67,
                    imageURL: nil
                ),
                .init(
                    id: "8",
                    name: "Dirk",
                    chipCount: 32.10,
                    imageURL: nil
                ),
                .init(
                    id: "9",
                    name: "Sienna",
                    chipCount: 14.74,
                    imageURL: nil
                ),
            ],
            cookedDeck: deck
        )
        try hand.postSmallBlind()
        try hand.postBigBlind()
        try hand.bet(amount: 11.27)
        try hand.fold()
        try hand.fold()
        try hand.bet(amount: 11.27)
        try hand.fold()
        try hand.fold()
        try hand.fold()
        try hand.fold()
        try hand.bet(amount: 10.77)
        
        // flop
        try hand.check()
        try hand.bet(amount: 1.50)
        try hand.fold()
        
        print(hand.log.debugDescription)
    }
}
