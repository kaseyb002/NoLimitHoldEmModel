import Foundation

public struct NoLimitHoldEmHand: Hashable, Codable, Identifiable {
    // MARK: - Initialized Properties
    public let id: String
    public let started: Date
    public let blinds: Blinds
    public let board: [Card]
    
    // MARK: - Hand Progression
    public internal(set) var state: State = .waitingForSmallBlind
    public internal(set) var round: Round = .preflop
    public internal(set) var playerHands: [PlayerHand]
    
    // MARK: - Results
    public internal(set) var pots: [Pot] = []
    public internal(set) var potWinners: [PotResult] = []
    public internal(set) var ended: Date?
    
    // MARK: - Log
    public internal(set) var log: Log
    
    // MARK: - Config
    public var autoProgress: AutoProgressConfig = .init()
    
    public enum State: Hashable, Codable {
        case waitingForSmallBlind
        case waitingForBigBlind
        case waitingForPlayerToAct(playerIndex: Int)
        case waitingToProgressToNextRound
        case handComplete
    }
    
    public struct AutoProgressConfig: Hashable, Codable {
        public var autoMoveToNextRound: Bool = true
    }
}
