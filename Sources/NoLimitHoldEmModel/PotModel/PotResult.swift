import Foundation

public struct PotResult: Hashable, Codable {
    public let pot: Pot
    public let winningHands: Set<WinningHand>
    
    public init(
        pot: Pot,
        winningHands: Set<WinningHand>
    ) {
        self.pot = pot
        self.winningHands = winningHands
    }
}
