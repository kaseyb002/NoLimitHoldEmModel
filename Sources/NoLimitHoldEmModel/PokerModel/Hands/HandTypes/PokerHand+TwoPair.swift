import Foundation

extension PokerHand {
    public struct TwoPair: Hashable, Codable {
        public let higher: Card
        public let lower: Card
        public let remainder: Card
        
        init?(cards unsortedCards: [Card]) {
            let cards: [Card] = unsortedCards.sorted(by: { $0.rank > $1.rank })
            guard let higher: Card = cards.kind(of: 2),
                  let lower: Card = cards.reversed().kind(of: 2),
                  lower.rank != higher.rank,
                  let remainder: Card = cards.filter({ [lower.rank, higher.rank].contains($0.rank) == false }).first
            else {
                return nil
            }
            
            self.lower = lower
            self.higher = higher
            self.remainder = remainder
        }
    }
}
