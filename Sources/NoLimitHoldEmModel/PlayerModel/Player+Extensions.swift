import Foundation

extension Player {
    public var debugDescription: String {
        "\(name) - \(chipCount.moneyString)"
    }
}

extension [Player] {
    public var debugDescription: String {
        var description: String = "----Players----"
        for player in self {
            description += "\n"
            description += player.debugDescription
        }
        return description
    }
}

