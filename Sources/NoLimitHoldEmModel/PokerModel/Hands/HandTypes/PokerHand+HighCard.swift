import Foundation

extension PokerHand {
    public struct HighCard: Hashable, Codable {
        public let cards: [Card]
        
        init(cards: [Card]) {
            self.cards = cards
                .sorted(by: { $0.rank > $1.rank })
        }
    }
}
