import Foundation

extension [PotResult] {
    public func debugDescription(playerNameByID: (_ id: String) -> String) -> String {
        var description: String = "----Pot Results----"

        for (index, potResult) in enumerated() {
            description += "\n"
            description += "Pot \(index + 1): \(potResult.pot.amount.moneyString)"

            for winningHand in potResult.winningHands {
                description += "\n"
                description += "\(playerNameByID(winningHand.playerID)) with \(winningHand.pokerHand.description)"
            }
            description += "\n"
        }

        return description
    }
}
