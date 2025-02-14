import Foundation
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

    @Test func missingMoney() async throws {
        let deck: Deck = .init(cards: [
            // mary
            .fake(),
            .fake(),
            // me
            .init(rank: .ace, suit: .diamond),
            .init(rank: .nine, suit: .diamond),
            // susan
            .fake(),
            .fake(),
            // richard
            .init(rank: .queen, suit: .heart),
            .init(rank: .queen, suit: .spade),
            // emily
            .init(rank: .two, suit: .club),
            .init(rank: .two, suit: .heart),
            // charles
            .fake(),
            .fake(),
            // linda
            .fake(),
            .fake(),
            // board
            .init(rank: .five, suit: .spade),
            .init(rank: .king, suit: .spade),
            .init(rank: .six, suit: .spade),
            .init(rank: .six, suit: .diamond),
            .init(rank: .two, suit: .spade),
        ])
        var hand: NoLimitHoldEmHand = try .init(
            blinds: .init(
                0.50,
                1.00
            ),
            players: [
                .init(
                    id: "mary",
                    name: "Mary",
                    chipCount: 23.75,
                    imageURL: nil
                ),
                .init(
                    id: "me",
                    name: "Me",
                    chipCount: 74.25,
                    imageURL: nil
                ),
                .init(
                    id: "susan",
                    name: "Susan",
                    chipCount: 1.75,
                    imageURL: nil
                ),
                .init(
                    id: "richard",
                    name: "Richard",
                    chipCount: 0.25,
                    imageURL: nil
                ),
                .init(
                    id: "emily",
                    name: "Emily",
                    chipCount: 101.25,
                    imageURL: nil
                ),
                .init(
                    id: "charles",
                    name: "Charles",
                    chipCount: 28.50,
                    imageURL: nil
                ),
                .init(
                    id: "linda",
                    name: "Linda",
                    chipCount: 20.25,
                    imageURL: nil
                ),
            ],
            cookedDeck: deck
        )
        try hand.postSmallBlind()
        
        try hand.postBigBlind()
        
        try hand.call()
        
        try hand.call()
        try hand.bet(amount: 3)
        try hand.fold()
        try hand.fold()
        try hand.fold()
        try hand.fold()
        try hand.fold()
        while hand.isReadyForNextRound {
            hand.progressRoundIfReady()
        }
        let starting: Decimal = hand.playerHands.reduce(.zero) { $0 + $1.startingChipCount }
        let ending: Decimal = hand.playerHands.reduce(.zero) { $0 + $1.player.chipCount }
        #expect(starting == ending)
    }
}
