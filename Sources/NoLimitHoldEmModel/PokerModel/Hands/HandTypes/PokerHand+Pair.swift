import Foundation

extension PokerHand {
    public struct Pair: Hashable, Codable {
        public let pairCard: Card
        public let remainder: [Card]
        
        init?(cards: [Card]) {
            guard let pair: Card = cards.kind(of: 2) else {
                return nil
            }
            self.pairCard = pair
            
            let remainder: [Card] = cards
                .filter { $0.rank != pair.rank }
                .sorted(by: { $0.rank > $1.rank })
            guard Set(remainder.map { $0.rank }).count == 3 else {
                return nil
            }
            self.remainder = remainder
        }
    }
}
