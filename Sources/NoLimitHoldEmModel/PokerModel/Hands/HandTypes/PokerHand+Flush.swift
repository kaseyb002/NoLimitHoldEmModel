import Foundation

extension PokerHand {
    public struct Flush: Hashable, Codable, Sendable {
        /// Sorted highest to lowest value
        public let cards: [Card]
        
        init?(cards: [Card]) {
            guard cards.isFlush else {
                return nil
            }
            
            self.cards = cards.sorted(by: { $0.rank > $1.rank })
        }
    }
}
