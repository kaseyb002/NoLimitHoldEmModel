import Foundation

extension PokerHand {
    public struct ThreeOfAKind: Hashable, Codable {
        public let threeOfAKind: Card
        public let remainder: [Card]
        
        init?(cards: [Card]) {
            guard let threeOfAKind: Card = cards.kind(of: 3) else {
                return nil
            }
            self.threeOfAKind = threeOfAKind
            
            let remainder: [Card] = cards
                .filter { $0.rank != threeOfAKind.rank }
                .sorted(by: { $0.rank > $1.rank })
            guard Set(remainder.map { $0.rank }).count == 2 else {
                return nil
            }
            self.remainder = remainder
        }
    }
}
