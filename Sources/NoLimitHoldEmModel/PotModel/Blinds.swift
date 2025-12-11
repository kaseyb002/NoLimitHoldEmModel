import Foundation

public struct Blinds: Hashable, Codable, Identifiable, Sendable {
    public let smallBlind: Decimal
    public let bigBlind: Decimal
    
    public init(smallBlind: Decimal, bigBlind: Decimal) {
        self.smallBlind = smallBlind
        self.bigBlind = bigBlind
    }
    
    public init(_ smallBlind: Double, _ bigBlind: Double) {
        self.smallBlind = .init(floatLiteral: smallBlind)
        self.bigBlind = .init(floatLiteral: bigBlind)
    }
    
    public var id: String {
        "\(smallBlind.moneyString)-\(bigBlind.moneyString)"
    }
}
