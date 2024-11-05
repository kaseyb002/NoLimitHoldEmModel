import Foundation

extension Player {
    public static func fake(
        id: String = UUID().uuidString,
        name: String = Lorem.firstName,
        chipCount: Decimal = .init(
            integerLiteral: Bool.random(withProbability: 0.9) ? .random(in: 1...20) * 100 : .zero
        ),
        imageURL: URL? = .randomImageURL
    ) -> Player {
        .init(
            id: id,
            name: name,
            chipCount: chipCount,
            imageURL: imageURL
        )
    }
}
