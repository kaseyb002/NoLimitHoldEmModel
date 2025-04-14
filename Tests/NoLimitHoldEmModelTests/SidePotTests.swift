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

    @Test func missingMoney2() async throws {
        let deck: Deck = .init(cards: [
            // mary
            .init(rank: .ace, suit: .spade),
            .init(rank: .king, suit: .diamond),
            // me
            .init(rank: .ace, suit: .diamond),
            .init(rank: .king, suit: .heart),
            // linda
            .fake(),
            .fake(),
            // board
            .init(rank: .four, suit: .spade),
            .init(rank: .nine, suit: .diamond),
            .init(rank: .ace, suit: .heart),
            .init(rank: .jack, suit: .club),
            .init(rank: .five, suit: .club),
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
                    chipCount: 177,
                    imageURL: nil
                ),
                .init(
                    id: "me",
                    name: "Me",
                    chipCount: 301.50,
                    imageURL: nil
                ),
                .init(
                    id: "linda",
                    name: "Linda",
                    chipCount: 24,
                    imageURL: nil
                ),
            ],
            cookedDeck: deck
        )
        try hand.postSmallBlind()
        
        try hand.postBigBlind()
        
        try hand.fold()
        
        try hand.bet(amount: 12)
        try hand.bet(amount: 24)
        try hand.bet(amount: 84)
        try hand.call()
        try hand.bet(amount: 12)
        try hand.bet(amount: 203.50)
        try hand.call()
        while hand.isReadyForNextRound {
            hand.progressRoundIfReady()
        }
        let starting: Decimal = hand.playerHands.reduce(.zero) { $0 + $1.startingChipCount }
        let ending: Decimal = hand.playerHands.reduce(.zero) { $0 + $1.player.chipCount }
        #expect(starting == ending)
    }
    
    @Test func missingMoney3() throws {
        /*
         Hand ID: 5E85F61C-A04F-4C7C-BDF2-6CE876C53637
         Started Apr 13, 2025 7:52:30PM
         
         ----Players----
         Smith has $28.25.
         Me has $131.50.
         Mozart has $2.25.
         Mizoguchi has $34.
         Beethoven has $13.50.
         Epstein has $40.50.
         
         ----Preflop----
         Smith posts small blind of $0.50.
         Me posts big blind of $1.
         Mozart calls $1.
         Mizoguchi folds.
         Beethoven folds.
         Epstein calls $1.
         Smith calls $0.50.
         Me checks.
         
         ----Flop----
         Board: A♠️ 9❤️ K♠️
         Smith bets $3.
         Me bets $7.
         Mozart folds.
         Epstein folds.
         Smith calls $4.
         
         ----Turn----
         Board: A♠️ 9❤️ K♠️ A♣️
         Smith checks.
         Me bets $18.
         Smith calls $18.
         
         ----River----
         Board: A♠️ 9❤️ K♠️ A♣️ 4❤️
         Smith bets $1.
         Me bets $55.
         Smith is all in for $1.25.
         
         ----Results----
         Board: A♠️ 9❤️ K♠️ A♣️ 4❤️
         Smith has J♠️ 9♣️.
         Me has 9♦️ 2♣️.
         
         ----Pots----
         Pot 1: $58.50
         Players: Epstein, Me, Mozart, Smith
         
         
         ----Pot Winners----
         Pot 1: $58.50
         Smith with pocket cards: J♠️ 9♣️
         Two Pair: 9❤️ 9♣️ K♠️ A♠️ A♣️
         ----
         Me with pocket cards: 9♦️ 2♣️
         Two Pair: 9❤️ 9♦️ K♠️ A♠️ A♣️
         ----
         
         ----Gains/Losses----
         Smith gained $1.25
         Me gained $1.25
         Mozart lost $1
         Epstein lost $1
         */
        let deck: Deck = .init(cards: [
            // Board: A♠️ 9❤️ K♠️ A♣️ 4❤️
            .init(rank: .four, suit: .heart),
            .init(rank: .ace, suit: .club),
            .init(rank: .king, suit: .spade),
            .init(rank: .nine, suit: .heart),
            .init(rank: .ace, suit: .spade),

            // Epstein
            .fake(), .fake(),

            // Beethoven
            .fake(), .fake(),

            // Mizoguchi
            .fake(), .fake(),

            // Mozart
            .fake(), .fake(),

            // Me: 9♦️ 2♣️
            .init(rank: .two, suit: .club),
            .init(rank: .nine, suit: .diamond),

            // Smith: J♠️ 9♣️
            .init(rank: .nine, suit: .club),
            .init(rank: .jack, suit: .spade),
        ])
        
        var hand = try NoLimitHoldEmHand(
            blinds: .init(0.50, 1.00),
            players: [
                .init(id: "smith", name: "Smith", chipCount: 28.25, imageURL: nil),
                .init(id: "me", name: "Me", chipCount: 131.50, imageURL: nil),
                .init(id: "mozart", name: "Mozart", chipCount: 2.25, imageURL: nil),
                .init(id: "mizoguchi", name: "Mizoguchi", chipCount: 34, imageURL: nil),
                .init(id: "beethoven", name: "Beethoven", chipCount: 13.50, imageURL: nil),
                .init(id: "epstein", name: "Epstein", chipCount: 40.50, imageURL: nil),
            ],
            cookedDeck: deck
        )
        
        // ----Preflop----
        try hand.postSmallBlind() // Smith posts $0.50
        hand.assertNoChipLossDuringHand()
        try hand.postBigBlind()   // Me posts $1
        hand.assertNoChipLossDuringHand()

        try hand.call()           // Mozart calls $1
        hand.assertNoChipLossDuringHand()
        try hand.fold()           // Mizoguchi folds
        hand.assertNoChipLossDuringHand()
        try hand.fold()           // Beethoven folds
        hand.assertNoChipLossDuringHand()
        try hand.call()           // Epstein calls $1
        hand.assertNoChipLossDuringHand()
        try hand.call()           // Smith calls $0.50
        hand.assertNoChipLossDuringHand()
        try hand.check()          // Me checks
        hand.assertNoChipLossDuringHand()

        // ----Flop: A♠️ 9❤️ K♠️ ----
        print("### flop")
        try hand.bet(amount: 3)   // Smith bets $3
        hand.assertNoChipLossDuringHand()
        try hand.bet(amount: 7)   // Me raises to $7
        hand.assertNoChipLossDuringHand()
        try hand.fold()           // Mozart folds
        hand.assertNoChipLossDuringHand()
        try hand.fold()           // Epstein folds
        hand.assertNoChipLossDuringHand()
        try hand.call()           // Smith calls $4
        hand.assertNoChipLossDuringHand()

        // ----Turn: A♠️ 9❤️ K♠️ A♣️ ----
        print("### turn")
        try hand.check()          // Smith checks
        hand.assertNoChipLossDuringHand()
        try hand.bet(amount: 18)  // Me bets $18
        hand.assertNoChipLossDuringHand()
        try hand.call()           // Smith calls $18
        hand.assertNoChipLossDuringHand()

        // ----River: A♠️ 9❤️ K♠️ A♣️ 4❤️ ----
        print("### river")
        try hand.bet(amount: 1)   // Smith bets $1
        hand.assertNoChipLossDuringHand()
        try hand.bet(amount: 55)  // Me raises to $55
        hand.assertNoChipLossDuringHand()
        try hand.call()           // Smith is all in for $1.25
        
        // ----Assertion: No chip loss----
        let totalStarting = hand.playerHands.reduce(Decimal.zero) { $0 + $1.startingChipCount }
        let totalEnding = hand.playerHands.reduce(Decimal.zero) { $0 + $1.player.chipCount }
        print(totalStarting)
        print(totalEnding)
        print(hand.log.debugDescription)
        #expect(totalStarting == totalEnding, "Mismatch: started with \(totalStarting), ended with \(totalEnding)")
    }
    
    @Test func badSplit1() throws {
        var hand = try NoLimitHoldEmHand(
            blinds: .init(0.50, 1.00),
            players: [
                .init(id: "smith", name: "Smith", chipCount: 5.25, imageURL: nil),
                .init(id: "me", name: "Me", chipCount: 10.00, imageURL: nil),
            ],
            cookedDeck: .init(cards: [
                .init(rank: .ace, suit: .club),
                .init(rank: .king, suit: .club),
                .init(rank: .queen, suit: .club),
                .init(rank: .jack, suit: .club),
                .init(rank: .ten, suit: .club),
                
                .fake(),
                .fake(),
                
                .fake(),
                .fake(),
            ])
        )
        try hand.postSmallBlind()
        try hand.postBigBlind()
        try hand.call()
        try hand.check()
        
        try hand.check()
        try hand.check()
        
        try hand.check()
        try hand.check()
        
        try hand.bet(amount: .greatestFiniteMagnitude)
        try hand.call()
        
        let totalStarting = hand.playerHands.reduce(Decimal.zero) { $0 + $1.startingChipCount }
        let totalEnding = hand.playerHands.reduce(Decimal.zero) { $0 + $1.player.chipCount }
        print(totalStarting)
        print(totalEnding)
        print(hand.log.debugDescription)
        #expect(
            totalStarting == totalEnding,
            "Mismatch: started with \(totalStarting), ended with \(totalEnding)"
        )
        #expect(
            hand.playerHands[0].player.chipCount == 5.50
        )
        #expect(
            hand.playerHands[1].player.chipCount == 9.75
        )
    }
}

extension NoLimitHoldEmHand {
    func assertNoChipLossDuringHand(file: StaticString = #file, line: UInt = #line) {
        let totalStarting = playerHands.reduce(.zero) {
            $0 + $1.startingChipCount
        }
        let totalEnding = playerHands.reduce(.zero) {
            $0 + $1.player.chipCount
        } + totalPotAndBets
        #expect(
            totalStarting == totalEnding,
            "Mismatch: started with \(totalStarting), ended with \(totalEnding)"
        )
    }

    func assertNoChipLossAtEndOfHand(file: StaticString = #file, line: UInt = #line) {
        let totalStarting = playerHands.reduce(.zero) {
            $0 + $1.startingChipCount
        }
        let totalEnding = playerHands.reduce(.zero) {
            $0 + $1.player.chipCount
        }
        #expect(
            totalStarting == totalEnding,
            "Mismatch: started with \(totalStarting), ended with \(totalEnding)"
        )
    }
}
