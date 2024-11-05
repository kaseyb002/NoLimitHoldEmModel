import Foundation

extension PokerHand {
    public struct StraightFlush: Hashable, Codable {
        public let highCard: Card
        
        init?(cards: [Card]) {
            guard cards.isFlush else {
                return nil
            }
            let sortedCards: [Card] = cards.sorted(by: { $0.rank < $1.rank })
            guard sortedCards.isStraight else {
                return nil
            }
            
            if sortedCards.first?.rank == .two {
                self.highCard = sortedCards.dropLast().last!
            } else {
                self.highCard = sortedCards.last!
            }
        }
        
        init(highCard: Card) {
            self.highCard = highCard
        }
    }
}
