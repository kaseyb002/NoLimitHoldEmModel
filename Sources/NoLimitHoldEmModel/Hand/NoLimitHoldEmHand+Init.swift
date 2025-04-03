import Foundation

extension NoLimitHoldEmHand {
    // MARK: - Init
    public init(
        id: String = UUID().uuidString,
        started: Date = .init(),
        blinds: Blinds,
        players: [Player],
        cookedDeck: Deck? = nil
    ) throws {
        guard players.count > 1 else {
            throw NoLimitHoldEmHandError.insufficientPlayers
        }
        
        var deck: Deck = cookedDeck ?? .init()
        if cookedDeck == nil {
            deck.shuffle()
        }
        
        let playerHands: [PlayerHand] = players.map { player in
            PlayerHand(player: player)
        }
        let pocketCards: [String: PocketCards] = Self.dealCards(
            to: players,
            deck: &deck
        )
        
        let board: [Card] = Self.makeBoard(deck: &deck)
        
        self.id = id
        self.started = started
        self.board = board
        self.blinds = blinds
        self.playerHands = playerHands
        self.pocketCards = pocketCards
        self.log = .init(
            handID: id,
            started: started,
            startingPlayerHands: playerHands,
            board: board,
            pocketCards: pocketCards,
            blinds: blinds
        )
    }
    
    public static func dealCards(
        to players: [Player],
        deck: inout Deck
    ) -> [String: PocketCards] {
        var allPocketCards: [String: PocketCards] = [:]
        for player in players {
            let pocketCards: PocketCards = .init(
                first: deck.cards.removeLast(),
                second: deck.cards.removeLast()
            )
            allPocketCards[player.id] = pocketCards
        }
        return allPocketCards
    }
    
    public static func makeBoard(deck: inout Deck) -> [Card] {
        var board: [Card] = []
        for _ in 1...5 {
            board.append(deck.cards.removeLast())
        }
        return board
    }
}
