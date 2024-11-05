import Foundation

extension Card {
    public static func fake(
        rank: Rank = Rank.allCases.randomElement()!,
        suit: Suit = Suit.allCases.randomElement()!
    ) -> Card {
        .init(
            rank: rank,
            suit: suit
        )
    }
}
