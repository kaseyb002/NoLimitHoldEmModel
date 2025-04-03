import Foundation

extension NoLimitHoldEmHand {
    public struct Log: Codable, Hashable {        
        public let handID: String
        public let started: Date
        public let startingPlayerHands: [PlayerHand]
        public let board: [Card]
        public let blinds: Blinds
        public let pocketCards: [String: PocketCards]
        public var actions: Actions
        public var results: Results?
        
        public enum CodingKeys: String, CodingKey {
            case handID = "handId"
            case started
            case startingPlayerHands
            case board
            case blinds
            case actions
            case results
            case pocketCards
        }
        
        // MARK: - Action Groups
        public struct Actions: Codable, Hashable {
            public internal(set) var preflopActions: [PlayerAction] = []
            public internal(set) var flopActions: [PlayerAction] = []
            public internal(set) var turnActions: [PlayerAction] = []
            public internal(set) var riverActions: [PlayerAction] = []
            
            public init(
                preflopActions: [PlayerAction] = [],
                flopActions: [PlayerAction] = [],
                turnActions: [PlayerAction] = [],
                riverActions: [PlayerAction] = []
            ) {
                self.preflopActions = preflopActions
                self.flopActions = flopActions
                self.turnActions = turnActions
                self.riverActions = riverActions
            }
        }
        
        // MARK: - PlayerAction Type
        public struct PlayerAction: Codable, Hashable {
            public let playerID: String
            public let decision: Decision
            public let timestamp: Date
            
            public enum CodingKeys: String, CodingKey {
                case playerID = "playerId"
                case decision
                case timestamp
            }
            
            public enum Decision: Codable, Hashable {
                case postSmallBlind(amount: Decimal)
                case postBigBlind(amount: Decimal)
                case fold
                case check
                case bet(amount: Decimal, isAllIn: Bool)
                case call(amount: Decimal, isAllIn: Bool)
                case show(cards: ShowCards)
            }
            
            public init(
                playerID: String,
                decision: Decision,
                timestamp: Date = .init()
            ) {
                self.playerID = playerID
                self.decision = decision
                self.timestamp = timestamp
            }
            
            public var id: String {
                String(hashValue)
            }
        }
        
        // MARK: - Results Type
        public struct Results: Codable, Hashable {
            public let pots: [Pot]
            public let potWinners: [PotResult]
            public let ended: Date
            public let endPlayerHands: [PlayerHand]
        }
        
        // MARK: - Init
        internal init(
            handID: String,
            started: Date,
            startingPlayerHands: [PlayerHand],
            board: [Card],
            pocketCards: [String: PocketCards],
            blinds: Blinds
        ) {
            self.handID = handID
            self.started = started
            self.startingPlayerHands = startingPlayerHands
            self.board = board
            self.blinds = blinds
            self.pocketCards = pocketCards
            self.actions = .init()
        }
    }
}

// MARK: - Writing to log
extension NoLimitHoldEmHand.Log {
    internal mutating func log(
        action: PlayerAction,
        round: NoLimitHoldEmHand.Round
    ) {
        switch round {
        case .preflop:
            actions.preflopActions.append(action)
            
        case .flop:
            actions.flopActions.append(action)
            
        case .turn:
            actions.turnActions.append(action)
            
        case .river:
            actions.riverActions.append(action)
        }
    }
}
