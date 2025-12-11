import Foundation

public struct Player: Hashable, Codable, Sendable {
    public let id: String
    public var name: String
    public var chipCount: Decimal
    public var imageURL: URL?
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case chipCount
        case imageURL = "imageUrl"
    }
    
    public init(
        id: String,
        name: String,
        chipCount: Decimal,
        imageURL: URL?
    ) {
        self.id = id
        self.name = name
        self.chipCount = chipCount
        self.imageURL = imageURL
    }
}
