import Foundation

// MARK: - Collecting Bets and Pots
extension NoLimitHoldEmHand {
    internal mutating func collectBets(
        restrictTo playerHandsToCollectFrom: [PlayerHand]? = nil
    ) {
        guard maxOutstandingBet > .zero else {
            return
        }
        
        let bettingPlayerHands: [PlayerHand] = playerHandsToCollectFrom ?? playerHands
            .filter { $0.currentBet > .zero }
        let bettingPlayerIds: Set<String> = Set(
            bettingPlayerHands
                .map { $0.player.id }
        )
        
        if pots.isEmpty || pots[pots.count - 1].isFull {
            pots.append(.init(
                playerIds: bettingPlayerIds
            ))
        }
        
        // if no player is all in, there is no need for a side pot
        guard bettingPlayerHands.contains(where: { $0.isAllIn }) else {
            collectBetsWithoutCheckingForSidePots()
            return
        }

        let smallestAllInBet: Decimal = bettingPlayerHands
            .filter { $0.isAllIn }
            .map { $0.currentBet }
            .min() ?? .zero
        // look at each player's bet, not the pot as a whole (see testSidePot5() for why)
        let overbetAmount: Decimal = bettingPlayerHands
            .filter { $0.status == .in }
            .map { $0.currentBet - smallestAllInBet }
            .reduce(.zero, +)
        
        guard overbetAmount > .zero else {
            collectBetsWithoutCheckingForSidePots()
            
            if overbetAmount == .zero {
                pots[pots.count - 1].isFull = true
            }
            
            return
        }
        
        let sidePotPlayerHands: [PlayerHand] = bettingPlayerHands
            .filter { $0.currentBet > smallestAllInBet }
        
        // down to 1 player in the side pot, which means
        // there is no need for a side pot because there's
        // no one for him to to bet against
        if sidePotPlayerHands.count == 1,
           let playerId: String = sidePotPlayerHands.first?.player.id,
           let playerIndex: Int = self.playerHands.firstIndex(where: { $0.player.id == playerId }) {
            let refundAmount: Decimal = self.playerHands[playerIndex].currentBet - smallestAllInBet
            self.playerHands[playerIndex].currentBet = smallestAllInBet
            self.playerHands[playerIndex].player.chipCount += refundAmount
            collectBetsWithoutCheckingForSidePots()
            return
        }
        
        for bettingPlayerHand in bettingPlayerHands {
            pots[pots.count - 1].amount += min(bettingPlayerHand.currentBet, smallestAllInBet)
        }
        pots[pots.count - 1].isFull = true
        
        // now let's create our side pot
        // we only want to include players who have bet beyond the player who is all in
        let sidePotPlayerIds: Set<String> = Set(
            sidePotPlayerHands
                .map { $0.player.id }
        )
        let newSidePot: Pot = .init(playerIds: sidePotPlayerIds)
        pots.append(newSidePot)
        
        // subtract amount paid towards previous pot from remaining players' current bet
        for (index, playerHand) in self.playerHands.enumerated() {
            if sidePotPlayerIds.contains(playerHand.player.id) {
                playerHands[index].currentBet -= smallestAllInBet
            } else {
                playerHands[index].currentBet = .zero
            }
        }
        
        collectBets(restrictTo: playerHands.filter({ sidePotPlayerIds.contains($0.player.id) }))
    }
    
    internal mutating func collectBetsWithoutCheckingForSidePots() {
        for (index, player) in playerHands.enumerated() {
            var updatedPot: Pot = pots[pots.count - 1]
            updatedPot.amount += player.currentBet
            pots[pots.count - 1] = updatedPot
            playerHands[index].currentBet = .zero
        }
    }
    
    internal mutating func completeHand() {
        resetPlayersHaveMoved()
        
        var potWinners: [PotResult] = []
        for pot in pots {
            var winningHands: Set<WinningHand> = []
            for playerHand in activePlayerHands where pot.playerIds.contains(playerHand.player.id) {
                guard let pocketCards: PocketCards = pocketCards[playerHand.player.id] else {
                    continue
                }
                let cards: [Card] = board + [
                    pocketCards.first,
                    pocketCards.second
                ]
                let hand: PokerHand = try! cards.bestPokerHand()
                
                let thisHand: WinningHand = .init(
                    playerID: playerHand.player.id,
                    pokerHand: hand
                )
                guard let currentBestHand: PokerHand = winningHands.first?.pokerHand else {
                    winningHands = [thisHand]
                    continue
                }
                
                let isBetterHand: Bool? = hand.topRank > currentBestHand.topRank
                if isBetterHand == true {
                    winningHands = [thisHand]
                } else if isBetterHand == nil { // tie
                    winningHands.insert(thisHand)
                }
            }
            let potWinner: PotResult = .init(
                pot: pot,
                winningHands: winningHands
            )
            potWinners.append(potWinner)
        }
        
        self.potWinners = potWinners
        award(potWinners: potWinners)
        
        state = .handComplete
        let endedTimestamp: Date = .init()
        ended = endedTimestamp
        
        log.results = .init(
            pots: pots,
            potWinners: potWinners,
            ended: endedTimestamp,
            endPlayerHands: playerHands
        )
    }
    
    internal mutating func award(potWinners: [PotResult]) {
        for potWinner in potWinners where potWinner.winningHands.isEmpty == false {
            let winningsPerPlayer: Decimal
            var remainder: Decimal
            
            if potWinner.winningHands.count == 1 {
                winningsPerPlayer = potWinner.pot.amount
                remainder = .zero
            } else {
                // Ensure winningAmount is a factor of number of split pot players
                var winningAmount: Decimal = .zero
                while winningAmount < potWinner.pot.amount {
                    winningAmount += blinds.smallBlind * Decimal(integerLiteral: potWinner.winningHands.count)
                }
                winningsPerPlayer = winningAmount / Decimal(integerLiteral: potWinner.winningHands.count)
                remainder = potWinner.pot.amount - winningAmount
            }
            
            let winningPlayerIds: Set<String> = Set(
                potWinner
                    .winningHands
                    .map { $0.playerID }
            )
            
            for (index, playerHand) in self.playerHands.enumerated() {
                if winningPlayerIds.contains(playerHand.player.id) {
                    self.playerHands[index].player.chipCount += winningsPerPlayer
                }
            }
            
            guard remainder > .zero else {
                continue
            }
            
            // hand out remainder based with shortest stack getting first dibs
            let winnersByShortestStack: [WinningHand] = potWinner.winningHands
                .sorted(by: {
                    guard let lhsPlayerHand: PlayerHand = playerHand(byID: $0.playerID),
                          let rhsPlayerHand: PlayerHand = playerHand(byID: $1.playerID)
                    else {
                        return false
                    }
                    
                    return lhsPlayerHand.startingChipCount < rhsPlayerHand.startingChipCount
                })
            
            while remainder > .zero {
                for winner in winnersByShortestStack {
                    let amountToAward: Decimal = min(remainder, blinds.smallBlind)
                    guard let index: Int = index(byPlayerId: winner.playerID) else {
                        continue
                    }
                    playerHands[index].player.chipCount += amountToAward
                    remainder -= amountToAward
                }
            }
        }
    }
}
