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
}
