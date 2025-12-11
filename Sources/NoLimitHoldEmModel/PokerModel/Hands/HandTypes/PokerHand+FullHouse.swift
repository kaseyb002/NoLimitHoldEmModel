import Foundation

extension PokerHand {
    public struct FullHouse: Hashable, Codable, Sendable {
        public let threeOfAKind: Card
        public let remainingPair: Card
        
        init?(cards: [Card]) {
            guard let threeOfAKind: Card = cards.kind(of: 3) else {
                return nil
            }
            self.threeOfAKind = threeOfAKind
            
            let remainder: [Card] = cards
                .filter { $0.rank != threeOfAKind.rank }
            guard let remainingPair: Card = remainder.kind(of: 2) else {
                return nil
            }
            self.remainingPair = remainingPair
        }
    }
}
