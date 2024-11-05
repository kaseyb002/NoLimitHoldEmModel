import Foundation

extension [Card] {
    public func sorted() -> [Card] {
        sorted(by: { $0.rank < $1.rank })
    }
    
    public var debugDescription: String {
        map { $0.debugDescription }.joined(separator: " ")
    }
    
    public func kind(of n: Int) -> Card? {
        for card in self {
            let sameRanks: [Card] = filter { $0.rank == card.rank }
            if sameRanks.count == n {
                return card
            }
        }
        return nil
    }
    
    /// Assumes pre-sorted least -> greatest rank
    public var isStraight: Bool {
        let ranks: [Card.Rank] = map { $0.rank }
        if ranks == [.two, .three, .four, .five, .ace] {
            return true
        }
        let maxDiff: Int = ranks.max()!.value - ranks.min()!.value
        return maxDiff == 4 && Set(ranks).count == 5
    }
    
    public var isFlush: Bool {
        let suits: [Card.Suit] = map { $0.suit }
        return Set(suits).count == 1
    }
    
    /// Must contain >= 5 cards
    public var allPokerHandCombinations: [[Card]] {
        var combinations: [[Card]] = []
        
        guard count >= 5 else {
            return combinations
        }
        
        for i in 0..<(count - 4) {
            for j in (i + 1)..<(count - 3) {
                for k in (j + 1)..<(count - 2) {
                    for m in (k + 1)..<(count - 1) {
                        for n in (m + 1)..<count {
                            let combination: [Card] = [
                                self[i],
                                self[j],
                                self[k],
                                self[m],
                                self[n]
                            ]
                            combinations.append(combination)
                        }
                    }
                }
            }
        }
        
        return combinations
    }
    
    public func bestPokerHand() throws -> PokerHand {
        let allCombinations: [[Card]] = allPokerHandCombinations
        if allCombinations.isEmpty {
            throw PokerHandError.not5Cards
        }
        
        var bestHand: PokerHand = try .init(cards: allCombinations.first!)
        
        guard allCombinations.count > 1 else {
            return bestHand
        }
        
        for cards in allCombinations.suffix(from: 1) {
            let pokerHand: PokerHand = try .init(cards: cards)
            if (pokerHand.topRank > bestHand.topRank) == true {
                bestHand = pokerHand
            }
        }
        
        return bestHand
    }
    
    /// Assumes card arrays of equal length
    public static func > (lhs: [Card], rhs: [Card]) -> Bool? {
        let sortedLHS: [Card] = lhs.sorted(by: { $0.rank > $1.rank })
        let sortedRHS: [Card] = rhs.sorted(by: { $0.rank > $1.rank })
        for (lhsCard, rhsCard) in zip(sortedLHS, sortedRHS) {
            if let higher: Bool = lhsCard > rhsCard {
                return higher
            }
        }
        return nil
    }
}
