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
        
        let playerHands: [PlayerHand] = Self.dealCards(
            to: players,
            deck: &deck
        )
        
        let board: [Card] = Self.makeBoard(deck: &deck)
        
        self.id = id
        self.started = started
        self.board = board
        self.blinds = blinds
        self.playerHands = playerHands
        self.log = .init(
            handID: id,
            started: started,
            startingPlayerHands: playerHands,
            board: board,
            blinds: blinds
        )
    }
    
    public static func dealCards(
        to players: [Player],
        deck: inout Deck
    ) -> [PlayerHand] {
        var playerHands: [PlayerHand] = []
        
        for player in players {
            let pocketCards: PocketCards = .init(
                first: deck.cards.removeLast(),
                second: deck.cards.removeLast()
            )
            let playerHand: PlayerHand = .init(
                pocketCards: pocketCards, 
                player: player
            )
            playerHands.append(playerHand)
        }
        
        return playerHands
    }
    
    public static func makeBoard(deck: inout Deck) -> [Card] {
        var board: [Card] = []
        for _ in 1...5 {
            board.append(deck.cards.removeLast())
        }
        return board
    }
}
