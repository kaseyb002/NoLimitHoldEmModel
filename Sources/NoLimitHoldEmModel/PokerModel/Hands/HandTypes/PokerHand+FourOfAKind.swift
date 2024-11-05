import Foundation

extension PokerHand {
    public struct FourOfAKind: Hashable, Codable {
        public let fourOfAKind: Card
        public let remainder: Card
        
        init?(cards: [Card]) {
            guard let fourOfAKind: Card = cards.kind(of: 4) else {
                return nil
            }
            self.fourOfAKind = fourOfAKind
            
            let remainder: [Card] = cards
                .filter { $0.rank != fourOfAKind.rank }
            guard remainder.count == 1 else {
                return nil
            }
            self.remainder = remainder.first!
        }
    }
}
