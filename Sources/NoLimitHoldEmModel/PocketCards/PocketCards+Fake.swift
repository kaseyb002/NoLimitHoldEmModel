import Foundation

extension PocketCards {
    public static func fake(
        first: Card = .fake(),
        second: Card = .fake()
    ) -> PocketCards {
        var validSecond: Card = second
        while validSecond == first {
            validSecond = .fake()
        }
        return .init(
            first: first,
            second: validSecond
        )
    }
}
