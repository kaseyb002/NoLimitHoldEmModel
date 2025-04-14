import XCTest
@testable import NoLimitHoldEmModel

final class NoLimitHoldEmModelTests: XCTestCase {
    func testBestHand() throws {
        let cards: [Card] = [
            .init(rank: .ace, suit: .heart),
            .init(rank: .six, suit: .diamond),
            .init(rank: .ten, suit: .club),
            .init(rank: .three, suit: .diamond),
            .init(rank: .seven, suit: .diamond),
            
            .init(rank: .ace, suit: .diamond),
            .init(rank: .ten, suit: .diamond),
        ]
        let pokerHand: PokerHand = try cards.bestPokerHand()
        XCTAssertEqual(
            pokerHand.topRank,
            .flush(
                PokerHand.Flush(
                    cards:
                        [
                            .init(
                                rank: .three,
                                suit: .diamond
                            ),
                            .init(
                                rank: .six,
                                suit: .diamond
                            ),
                            .init(
                                rank: .seven,
                                suit: .diamond
                            ),
                            .init(
                                rank: .ten,
                                suit: .diamond
                            ),
                            .init(
                                rank: .ace,
                                suit: .diamond
                            ),
                        ]
                )!
            )
        )
        XCTAssertEqual(
            pokerHand.cards,
            [
                .init(rank: .three, suit: .diamond),
                .init(rank: .six, suit: .diamond),
                .init(rank: .seven, suit: .diamond),
                .init(rank: .ten, suit: .diamond),
                .init(rank: .ace, suit: .diamond),
            ]
        )
    }

    func testBasicHand() throws {
        var hand: NoLimitHoldEmHand = try .fake()
        try hand.postSmallBlind()
        try hand.postBigBlind()
        var pot: Decimal = hand.totalCollectedPot
        + .init(integerLiteral: 25)
        + .init(integerLiteral: 50) // blinds
        XCTAssert(hand.playerHands.suffix(8).allSatisfy({ $0.currentBet == .zero }))
        XCTAssertEqual(hand.playerHands[0].currentBet, .init(integerLiteral: 25))
        XCTAssertEqual(hand.playerHands[1].currentBet, .init(integerLiteral: 50))
        XCTAssertEqual(hand.totalCollectedPot, .zero)
        
        // Pre-flop
        try hand.bet(amount: 150)
        pot += 150
        try hand.bet(amount: 150)
        pot += 150
        XCTAssertThrowsError(try hand.check())
        try hand.fold()
        try hand.fold()
        try hand.fold()
        try hand.fold()
        try hand.fold()
        try hand.bet(amount: 150)
        pot += 150
        try hand.bet(amount: 125)
        pot += 125
        try hand.bet(amount: 100)
        pot += 100
        XCTAssert(hand.activePlayerHands.allSatisfy({ $0.player.chipCount == 1350 }))
        
        // Flop
        XCTAssertEqual(hand.round, .flop)
        XCTAssertEqual(hand.totalCollectedPot, pot)
        try hand.check()
        try hand.check()
        try hand.check()
        try hand.check()
        try hand.check()
        
        // Turn
        XCTAssertEqual(hand.round, .turn)
        XCTAssertEqual(hand.totalCollectedPot, pot)
        try hand.bet(amount: 400)
        pot += 400
        try hand.fold()
        try hand.bet(amount: 400)
        pot += 400
        XCTAssertThrowsError(try hand.bet(amount: 500))
        try hand.bet(amount: 800)
        pot += 800
        try hand.fold()
        try hand.bet(amount: 400)
        pot += 400
        try hand.bet(amount: 400)
        pot += 400
        
        // River
        XCTAssertEqual(hand.round, .river)
        XCTAssertEqual(hand.totalCollectedPot, pot)
        try hand.check()
        try hand.check()
        try hand.bet(amount: 50)
        pot += 50
        try hand.fold()
        try hand.bet(amount: 50)
        pot += 50
        XCTAssertEqual(hand.state, .handComplete)
        XCTAssertEqual(hand.totalCollectedPot, pot)
        XCTAssertEqual(hand.playerHands[0].player.chipCount, 550)
        XCTAssertEqual(hand.playerHands[1].player.chipCount, 1350)
        XCTAssertEqual(hand.playerHands[2].player.chipCount, 500)
        XCTAssertEqual(hand.playerHands[3].player.chipCount, 3750)
        XCTAssertEqual(hand.playerHands[4].player.chipCount, 1500)
        XCTAssertEqual(hand.playerHands[5].player.chipCount, 1500)
        XCTAssertEqual(hand.playerHands[6].player.chipCount, 1500)
        XCTAssertEqual(hand.playerHands[7].player.chipCount, 1500)
        XCTAssertEqual(hand.playerHands[8].player.chipCount, 1500)
        XCTAssertEqual(hand.playerHands[9].player.chipCount, 1350)
    }
    
    func testSidePot() throws {
        var hand: NoLimitHoldEmHand = try .fakeForSidePot()
        try hand.postSmallBlind()
        try hand.postBigBlind()
        try hand.forceAllActivePlayersAllIn()
        let expectedPots: [Pot] = [
            .init(
                amount: .init(integerLiteral: 1000), // 200 * 5
                playerIds: ["1", "2", "3", "4", "5"]
            ),
            .init(
                amount: .init(integerLiteral: 1200), // 300 * 4
                playerIds: ["2", "3", "4", "5"]
            ),
            .init(
                amount: .init(integerLiteral: 1500), // 500 * 3
                playerIds: ["3", "4", "5"]
            ),
            .init(
                amount: .init(integerLiteral: 1000), // 500 * 2
                playerIds: ["4", "5"]
            ),
        ]
        print("------Expected Pots------")
        print(expectedPots.debugDescription)
        print("------Actual Pots------")
        print(hand.pots.debugDescription)
        XCTAssertEqual(
            expectedPots.map { $0.amount},
            hand.pots.map { $0.amount }
        )
        XCTAssertEqual(
            expectedPots.map { $0.playerIds }.flatMap { $0 }.sorted(by: { $0 < $1 }),
            hand.pots.map { $0.playerIds }.flatMap { $0 }.sorted(by: { $0 < $1 })
        )
        XCTAssertEqual(
            hand.playerHands.reduce(.zero) { $0 + $1.startingChipCount },
            hand.playerHands.reduce(.zero) { $0 + $1.player.chipCount }
        )
    }
    
    func testSidePot2() throws {
        var hand: NoLimitHoldEmHand = try .fakeForSidePot()
        try hand.postSmallBlind() // A at 25
        try hand.postBigBlind() // B at 50
        try hand.bet(amount: .init(integerLiteral: 50)) // C at 50
        try hand.bet(amount: .init(integerLiteral: 150)) // D at 150
        try hand.fold() // E out
        // insufficient raise from small blind
        XCTAssertThrowsError(try hand.bet(amount: .init(integerLiteral: 150)))
        try hand.bet(amount: .init(integerLiteral: 175)) // A all in at 200
        try hand.bet(amount: .init(integerLiteral: 150)) // B calls 150
        try hand.bet(amount: .init(integerLiteral: 150)) // C calls 150
        try hand.bet(amount: .init(integerLiteral: 50)) // D calls 50
        // flop
        try hand.bet(amount: .init(integerLiteral: 300)) // B all in at 500
        XCTAssertEqual(hand.playerHands[1].player.chipCount, .zero)
        try hand.bet(amount: .init(integerLiteral: 300)) // C calls 300
        try hand.bet(amount: .init(integerLiteral: 1200)) // D all in at 1500
        try hand.bet(amount: .init(integerLiteral: 500)) // C calls 500
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()
        let expectedPots: [Pot] = [
            .init(
                amount: .init(integerLiteral: 800), // 200 * 4
                playerIds: ["1", "2", "3", "4"]
            ),
            .init(
                amount: .init(integerLiteral: 900), // 300 * 3
                playerIds: ["2", "3", "4"]
            ),
            .init(
                amount: .init(integerLiteral: 1000), // 500 * 2
                playerIds: ["3", "4"]
            ),
        ]
        assertExpected(pots: expectedPots, against: hand.pots)
    }
    
    func testSidePot3() throws {
        var hand: NoLimitHoldEmHand = try .fakeForSidePot()
        try hand.postSmallBlind()
        try hand.postBigBlind()
        try hand.bet(amount: .init(integerLiteral: 100)) // C at 100
        try hand.bet(amount: .init(integerLiteral: 100)) // D at 100
        try hand.bet(amount: .init(integerLiteral: 100)) // E at 100
        // insufficient raise from small blind
        XCTAssertThrowsError(try hand.bet(amount: .init(integerLiteral: 150)))
        try hand.bet(amount: .init(integerLiteral: 75)) // A calls 75
        try hand.bet(amount: .init(integerLiteral: 200)) // B bets 200 to raise it to 250
        try hand.bet(amount: .init(integerLiteral: 150)) // C calls 150, at 250
        try hand.bet(amount: .init(integerLiteral: 150)) // D calls for 150, bet at 250
        try hand.fold() // E folds, with a remaining bet of 100
        try hand.bet(amount: .init(integerLiteral: 100)) // A calls 100, all in at 200
        
        var expectedPots: [Pot] = [
            .init(
                amount: .init(integerLiteral: 200 * 4 + 100), // 200 * 4 + E's folded 100 bet
                playerIds: ["1", "2", "3", "4", "5"],
                isFull: true
            ),
            .init(
                amount: .init(integerLiteral: 50 * 3),
                playerIds: ["2", "3", "4"]
            )
        ]
        assertExpected(
            pots: expectedPots,
            against: hand.pots
        )
        
        try hand.bet(amount: 250) // Bob all in for another 250
        try hand.bet(amount: .init(integerLiteral: 250 + 375)) // C calls and re-raise to 375
        try hand.bet(amount: .init(integerLiteral: 250 + 375)) // D calls all of it
        
        expectedPots = [
            .init(
                amount: .init(integerLiteral: 900),
                playerIds: ["1", "2", "3", "4", "5"],
                isFull: true
            ),
            .init(
                amount: .init(integerLiteral: 150 + 250 * 3), // 150 (previous round) + 250 * 3 (bets this round)
                playerIds: ["2", "3", "4"],
                isFull: true
            ),
            .init(
                amount: .init(integerLiteral: 375 + 375), // 375 * 2
                playerIds: ["3", "4"]
            ),
        ]
        assertExpected(
            pots: expectedPots,
            against: hand.pots
        )
    }
    
    func testSidePot4() throws {
        var hand: NoLimitHoldEmHand = try .fakeForSidePot()
        try hand.postSmallBlind()
        try hand.postBigBlind()
        try hand.fold() // C folds
        try hand.bet(amount: .init(integerLiteral: 400)) // Dave raises 400
        try hand.call() // Ed calls at 400
        try hand.bet(amount: .init(integerLiteral: 175)) // Al in at 200
        try hand.fold() // B folds
        
        var expectedPots: [Pot] = [
            .init(
                amount: .init(integerLiteral: 200 * 3 + 50),
                playerIds: ["1", "2", "4", "5"],
                isFull: true
            ),
            .init(
                amount: .init(integerLiteral: 200 * 2),
                playerIds: ["4", "5"]
            )
        ]
        assertExpected(
            pots: expectedPots,
            against: hand.pots
        )
        
        // flop
        try hand.bet(amount: .init(integerLiteral: 150)) // Dave raises 150
        try hand.bet(amount: .init(integerLiteral: 300)) // Ed re-raises to 300
        try hand.fold() // Dave folds
        
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()
        
        expectedPots = [
            .init(
                amount: .init(integerLiteral: 200 * 3 + 50),
                playerIds: ["1", "2", "4", "5"],
                isFull: true
            ),
            .init(
                amount: .init(integerLiteral: 200 * 2 + 150 + 300),
                playerIds: ["4", "5"]
            )
        ]
        assertExpected(
            pots: expectedPots,
            against: hand.pots
        )
    }
    
    
    private func assertExpected(
        pots expectedPots: [Pot],
        against actualPots: [Pot]
    ) {
        print("------Expected Pots------")
        print(expectedPots.debugDescription(playerNameByID: { $0 }))
        print("------Actual Pots------")
        print(actualPots.debugDescription(playerNameByID: { $0 }))
        XCTAssertEqual(
            expectedPots.map { $0.amount},
            actualPots.map { $0.amount }
        )
        XCTAssertEqual(
            expectedPots.map { $0.playerIds }.flatMap { $0 }.sorted(by: { $0 < $1 }),
            actualPots.map { $0.playerIds }.flatMap { $0 }.sorted(by: { $0 < $1 })
        )
    }
    
    func testPotCalculation() throws {
        // Create players
        let player1: Player = .init(id: "1", name: "Player 1", chipCount: 100, imageURL: nil)
        let player2: Player = .init(id: "2", name: "Player 2", chipCount: 100, imageURL: nil)
        let player3: Player = .init(id: "3", name: "Player 3", chipCount: 100, imageURL: nil)
        
        // Create the hand with blinds and players
        let blinds: Blinds = .init(smallBlind: 1, bigBlind: 2)
        var hand: NoLimitHoldEmHand = try .init(blinds: blinds, players: [player1, player2, player3])
        
        // Post blinds
        var expectedPot: Decimal = .init(integerLiteral: .zero)
        try hand.postSmallBlind()
        expectedPot += 1
        try hand.postBigBlind()
        expectedPot += 2
        XCTAssertEqual(hand.totalPotAndBets, expectedPot, "Pot calculation is incorrect.")
        
        // Player 3 bets 10
        try hand.bet(amount: 10)
        expectedPot += 10
        XCTAssertEqual(hand.totalPotAndBets, expectedPot, "Pot calculation is incorrect.")
        
        // Player 1 calls
        try hand.call()
        expectedPot += (10 - blinds.smallBlind)
        XCTAssertEqual(hand.totalPotAndBets, expectedPot, "Pot calculation is incorrect.")
        
        // Player 2 raises to 30
        try hand.bet(amount: 30)
        expectedPot += 30
        XCTAssertEqual(hand.playerHands[1].currentBet, 30 + blinds.bigBlind, "Pot calculation is incorrect.")
        XCTAssertEqual(hand.totalPotAndBets, expectedPot, "Pot calculation is incorrect.")
        
        // Player 3 calls
        try hand.call()
        expectedPot += 22
        XCTAssertEqual(hand.playerHands[2].currentBet, 32, "Pot calculation is incorrect.")
        XCTAssertEqual(hand.totalPotAndBets, expectedPot, "Pot calculation is incorrect.")
        
        // Player 1 folds
        try hand.fold()
        XCTAssertEqual(hand.round, .flop, "Incorrect round")
        
        // Player 3 bets 50
        try hand.bet(amount: 50)
        expectedPot += 50
        XCTAssertEqual(hand.totalPotAndBets, expectedPot, "Pot calculation is incorrect.")
        
        // Get the actual pot value from the hand
        let actualPot = hand.totalPotAndBets
        
        // Verify that the pot calculation is correct
        XCTAssertEqual(actualPot, expectedPot, "Pot calculation is incorrect.")
    }
    
    func testBasicSplitPot() throws {
        let deck: Deck = .fake2()
        var hand: NoLimitHoldEmHand = try .init(
            blinds: .init(smallBlind: 25, bigBlind: 50),
            players: [
                .fake(id: "1", name: "Player 1", chipCount: 1500),
                .fake(id: "2", name: "Player 2", chipCount: 1500),
            ],
            cookedDeck: deck
        )
        XCTAssertEqual(
            hand.pocketCards[hand.playerHands[0].player.id]?.first.rank,
            hand.pocketCards[hand.playerHands[1].player.id]?.first.rank
        )
        
        XCTAssertEqual(
            hand.pocketCards[hand.playerHands[0].player.id]?.second.rank,
            hand.pocketCards[hand.playerHands[1].player.id]?.second.rank
        )
        
        try hand.bet(amount: 1500)
        try hand.call()
        
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()

        XCTAssertEqual(hand.playerHands[0].player.chipCount, 1500)
        XCTAssertEqual(hand.playerHands[1].player.chipCount, 1500)
    }
    
    func testFiveWaySplitPotAndSidePots() throws {
        let deck: Deck = .fakeRoyalFlushBoard()
        var hand: NoLimitHoldEmHand = try .fakeForSidePot(
            deck: deck
        )
        try hand.forceAllActivePlayersAllIn()
    }
    
    func testAllInFolding() throws {
        let deck: Deck = .allInBug()
        var hand: NoLimitHoldEmHand = try .init(
            blinds: .init(
                5_000_000,
                10_000_000
            ),
            players: [
                .init(
                    id: "1",
                    name: "Me",
                    chipCount: 77_390_000_000,
                    imageURL: nil
                ),
                .init(
                    id: "2",
                    name: "Jackie",
                    chipCount: 2_100_000_000,
                    imageURL: nil
                ),
                .init(
                    id: "3",
                    name: "Uriel",
                    chipCount: 813_180_000,
                    imageURL: nil
                ),
                .init(
                    id: "4",
                    name: "inley",
                    chipCount: 1_120_000_000,
                    imageURL: nil
                ),
                .init(
                    id: "5",
                    name: "Trisha",
                    chipCount: 5_490_000_000,
                    imageURL: nil
                ),
                .init(
                    id: "6",
                    name: "Piper",
                    chipCount: 221_070_000,
                    imageURL: nil
                ),
                .init(
                    id: "7",
                    name: "Angelina",
                    chipCount: 962_440_000,
                    imageURL: nil
                ),
                .init(
                    id: "8",
                    name: "Brendon",
                    chipCount: 25_860_000,
                    imageURL: nil
                ),
                .init(
                    id: "9",
                    name: "Margarita",
                    chipCount: 414_810_000,
                    imageURL: nil
                ),
            ],
            cookedDeck: deck
        )
        try hand.postSmallBlind()
        try hand.postBigBlind()
        try hand.fold()
        try hand.fold()
        try hand.fold()
        try hand.fold()
        try hand.bet(amount: 30_000_000)
        try hand.bet(amount: 25_860_000)
        try hand.fold()
        try hand.bet(amount: 25_000_000)
        try hand.fold()
        
        // flop
        try hand.bet(amount: 8_460_000_000)
        try hand.fold()
        
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()
        hand.progressRoundIfReady()

        XCTAssert(hand.pots.count == 2)
        //8_555_860_000
        XCTAssertEqual(hand.pots.first?.amount, 87_580_000)
        XCTAssertEqual(hand.pots.last?.amount, 8_468_280_000)
    }
    
    func testSidePot5() throws {
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
    
    func testMinBet() throws {
        var hand: NoLimitHoldEmHand = try .fake(
            blinds: .init(0.05, 0.10),
            players: [
                .fake(chipCount: 10),
                .fake(chipCount: 10),
                .fake(chipCount: 10),
            ]
        )
        try hand.postSmallBlind()
        try hand.postBigBlind()
        XCTAssertEqual(hand.minBetForCurrentPlayer, 0.10)
        XCTAssertEqual(hand.minRaiseForCurrentPlayer, 0.20)
        try hand.bet(amount: 0.10)
        XCTAssertEqual(hand.minBetForCurrentPlayer, 0.05)
        XCTAssertEqual(hand.minRaiseForCurrentPlayer, 0.15)
        try hand.bet(amount: 0.05)
        try hand.check()
        try hand.bet(amount: 0.20)
        try hand.bet(amount: 0.50)
        print(hand.minRaiseForCurrentPlayer)
        print(hand.minBetForCurrentPlayer)
        try hand.bet(amount: 1)
        XCTAssert(hand.minBetForCurrentPlayer == 0.80)
        XCTAssert(hand.minRaiseForCurrentPlayer == 1.80)
    }
    
    func testMinBet2() throws {
        var hand: NoLimitHoldEmHand = try .fake(
            blinds: .init(0.05, 0.10),
            players: [
                .fake(chipCount: 10),
                .fake(chipCount: 10),
            ]
        )
        try hand.postSmallBlind()
        try hand.postBigBlind()
        try hand.bet(amount: 0.25)
        try hand.bet(amount: 2)
    }
    
    func testMinBet3() throws {
        var hand: NoLimitHoldEmHand = try .fake(
            blinds: .init(0.05, 0.10),
            players: [
                .fake(chipCount: 10),
                .fake(chipCount: 10),
            ]
        )
        try hand.postSmallBlind()
        try hand.postBigBlind()
        try hand.bet(amount: 0.80)
        try hand.bet(amount: 1.60)
    }
    
    func testParseHandJSON() throws {
        let data: Data = try loadJSON(fromFile: "hand")
        let decoder: JSONDecoder = .init()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let hand: NoLimitHoldEmHand = try decoder.decode(
            NoLimitHoldEmHand.self,
            from: data
        )
        print(hand.log.actions)
    }
    
    private func loadJSON(fromFile name: String) throws -> Data {
        guard let url: URL = Bundle.module.url(forResource: "hand", withExtension: "json") else {
            throw FileError.jsonFileNotFound(name: name)
        }
        return try Data(
            contentsOf: url,
            options: .mappedIfSafe
        )
    }
    
    private enum FileError: Error {
        case jsonFileNotFound(name: String)
    }
}

extension NoLimitHoldEmHand {
    mutating func forceAllActivePlayersAllIn() throws {
        for _ in 1...activePlayerHands.count {
            guard let currentPlayerHand else {
                continue
            }
            try bet(amount: currentPlayerHand.player.chipCount)
            progressRoundIfReady()
            progressRoundIfReady()
            progressRoundIfReady()
            progressRoundIfReady()
            progressRoundIfReady()
        }
    }
}



private extension NoLimitHoldEmHand {
    var missingMoney: Decimal {
        let beginningAmount: Decimal = playerHands.reduce(.zero) { $0 + $1.startingChipCount }
        let endingAmount: Decimal = playerHands.reduce(.zero) { $0 + $1.player.chipCount }
        return beginningAmount - endingAmount
    }
}
