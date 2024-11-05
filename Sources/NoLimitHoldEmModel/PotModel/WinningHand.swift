import Foundation

public struct WinningHand: Hashable, Codable {
    public let playerID: String
    public let pokerHand: PokerHand
    
    public init(
        playerID: String,
        pokerHand: PokerHand
    ) {
        self.playerID = playerID
        self.pokerHand = pokerHand
    }
}
