import Foundation

extension [Pot] {
    public func debugDescription(playerNameByID: (_ id: String) -> String) -> String {
        var description: String = "----Pots----"
        for (index, pot) in enumerated() {
            description += "\n"
            description += "Pot \(index + 1): \(pot.amount.moneyString)"
            description += "\n"
            let names: String = pot.playerIds
                .map { playerNameByID($0) }
                .sorted(by: { $0 < $1 })
                .joined(separator: ", ")
            description += "Players: \(names)"
        }
        return description
    }
}
