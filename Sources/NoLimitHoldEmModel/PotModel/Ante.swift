import Foundation

public struct Ante: Codable, Hashable, RawRepresentable, Sendable {
    public let rawValue: Decimal
    
    public typealias RawValue = Decimal
    
    public init(rawValue: Decimal) {
        self.rawValue = rawValue
    }
}
