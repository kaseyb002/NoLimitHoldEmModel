import Foundation

extension PocketCards {
    public var debugDescription: String {
        [first, second].debugDescription
    }
    
    public func isPocketPair(rank: Card.Rank) -> Bool {
        first.rank == rank && second.rank == rank
    }
    
    public var isSuited: Bool {
        first.suit == second.suit
    }
    
    public func hasRanks(
        _ firstRank: Card.Rank,
        and secondRank: Card.Rank
    ) -> Bool {
        contains(rank: firstRank) && contains(rank: secondRank)
    }
    
    public func contains(rank: Card.Rank) -> Bool {
        [first.rank, second.rank].contains(rank)
    }
    
    public func ranksAreGreaterThan(_ rank: Card.Rank) -> Bool {
        first.rank > rank && second.rank > rank
    }
    
    static let handStrengthMatrix: [[Int]] = [
        [  0,  2,  2,  3,  5,  8, 10, 13, 14, 14, 14, 14, 17],
        [  5,  1,  3,  3,  6, 10, 16, 20, 24, 25, 25, 26, 26],
        [  8,  9,  1,  5,  6, 10, 19, 26, 28, 28, 29, 30, 31],
        [ 12, 14, 15,  2,  6, 11, 17, 27, 33, 35, 35, 37, 38],
        [ 18, 20, 22, 21,  4, 10, 16, 25, 31, 40, 40, 41, 41],
        [ 32, 35, 36, 34, 31,  7, 17, 24, 28, 38, 47, 47, 49],
        [ 39, 50, 53, 48, 43, 42,  9, 21, 27, 33, 40, 53, 54],
        [ 45, 57, 66, 64, 59, 55, 52, 12, 25, 28, 37, 45, 55],
        [ 51, 60, 71, 70, 74, 68, 66, 61, 16, 27, 29, 38, 49],
        [ 44, 63, 75, 82, 89, 83, 73, 65, 58, 20, 28, 32, 39],
        [ 46, 67, 76, 85, 74, 90, 84, 78, 70, 62, 23, 36, 41],
        [ 49, 67, 77, 86, 89, 92, 96, 88, 81, 72, 76, 33, 46],
        [ 54, 69, 79, 87, 94, 97, 99,100, 95, 84, 86, 91, 22]
    ]
    /// 0 (weakest) to 1 (strongest)
    /// https://www.reddit.com/r/poker/comments/ig8nvw/poker_hand_rankings_chart/
    public var preflopStrength: Float {
        func chartIndex(for rank: Card.Rank) -> Int {
            return 12 - rank.value
        }

        let i = chartIndex(for: first.rank)
        let j = chartIndex(for: second.rank)
        let suited = first.suit == second.suit

        let strength: Int
        if i == j {
            strength = Self.handStrengthMatrix[i][j]
        } else if suited {
            strength = Self.handStrengthMatrix[min(i, j)][max(i, j)]
        } else {
            strength = Self.handStrengthMatrix[max(i, j)][min(i, j)]
        }

        return 1.0 - Float(strength) / 100.0
    }
    
    public static func distinctHandTypesSortedByStrength() -> [PocketCards] {
        let ranks = Card.Rank.allCases.reversed() // Start from .ace down to .two
        var results: [PocketCards] = []

        for (i, rank1) in ranks.enumerated() {
            for (j, rank2) in ranks.enumerated() {
                if i < j {
                    // Offsuit (e.g., AK offsuit)
                    let first = Card(rank: rank1, suit: .spade)
                    let second = Card(rank: rank2, suit: .heart)
                    results.append(PocketCards(first: first, second: second))
                } else if i > j {
                    // Suited (e.g., AK suited)
                    let first = Card(rank: rank2, suit: .spade)
                    let second = Card(rank: rank1, suit: .spade)
                    results.append(PocketCards(first: first, second: second))
                } else {
                    // Pair (e.g., AA)
                    let first = Card(rank: rank1, suit: .spade)
                    let second = Card(rank: rank1, suit: .heart)
                    results.append(PocketCards(first: first, second: second))
                }
            }
        }

        return results.sorted { $0.preflopStrength > $1.preflopStrength }
    }
}
