import Foundation

extension NoLimitHoldEmHand.Log {
    public var debugDescription: String {
        var log: String = """
        Hand ID: \(handID)
        Started \(started.string("MMM d, yyyy h:mm:ssa"))
        """
        
        // players
        appendLogSectionTitle(to: &log, title: "Players")
        for startingPlayerHand in startingPlayerHands {
            log += "\n"
            log += "\(startingPlayerHand.player.name) has \(startingPlayerHand.player.chipCount.moneyString)."
        }
        
        // actions
        appendLogActionsIfNeeded(
            to: &log,
            name: "Preflop",
            actions: actions.preflopActions
        )
        appendLogActionsIfNeeded(
            to: &log,
            name: "Flop",
            actions: actions.flopActions,
            board: Array(board[0...2])
        )
        appendLogActionsIfNeeded(
            to: &log,
            name: "Turn",
            actions: actions.turnActions,
            board: Array(board[0...3])
        )
        appendLogActionsIfNeeded(
            to: &log,
            name: "River",
            actions: actions.riverActions,
            board: board
        )
        
        // results
        if let results {
            appendLogSectionTitle(to: &log, title: "Results")
            log += "\n"
            log += "Board: \(board.debugDescription)"
            for endPlayerHand in results.endPlayerHands where endPlayerHand.status == .in {
                log += "\n"
                guard let pocketCards: PocketCards = pocketCards[endPlayerHand.player.id] else {
                    continue
                }
                log += "\(endPlayerHand.player.name) has \(pocketCards.debugDescription)."
            }
            
            appendLogSectionTitle(to: &log, title: "Pots")
            log += "\(results.pots.debugDescription(getName: { id in results.endPlayerHands.first(where: { $0.player.id == id })?.player.name ?? id }))"
            
            appendLogSectionTitle(to: &log, title: "Pot Winners")
            log += "\(results.potWinners.debugDescription(getName: { id in results.endPlayerHands.first(where: { $0.player.id == id })?.player.name ?? id }, getPocketCards: { id in pocketCards[id] } ))"
            
            appendLogSectionTitle(to: &log, title: "Gains/Losses")
            for playerHand in results.endPlayerHands {
                let diff: Decimal = playerHand.player.chipCount - playerHand.startingChipCount
                let absDiff: Decimal = abs(diff)
                if diff > .zero {
                    log += "\n"
                    log += "\(playerHand.player.name) gained \(absDiff.moneyString)"
                } else if diff < .zero {
                    log += "\n"
                    log += "\(playerHand.player.name) lost \(absDiff.moneyString)"
                    if absDiff == playerHand.startingChipCount {
                        log += " (broke)"
                    }
                }
            }
        } else {
            appendLogSectionTitle(to: &log, title: "Hand Incomplete")
        }
        
        return log
    }
    
    private func appendLogSectionTitle(
        to log: inout String,
        title: String
    ) {
        log += "\n"
        log += "\n"
        log += "----\(title)----"
    }
    
    private func appendLogActionsIfNeeded(
        to log: inout String,
        name: String,
        actions: [PlayerAction],
        board: [Card]? = nil
    ) {
        guard actions.isEmpty == false else {
            return
        }
        
        appendLogSectionTitle(to: &log, title: name)
        
        if let board {
            log += "\n"
            log += "Board: \(board.debugDescription)"
        }
        
        for action in actions {
            log += "\n"
            log += debugDescription(for: action)
        }
    }
    
    public func debugDescription(for action: NoLimitHoldEmHand.Log.PlayerAction) -> String {
        guard let playerHand: PlayerHand = playerHand(byID: action.playerID) else {
            return "Player not found"
        }
        var string: String = playerHand.player.name
        
        switch action.decision {
        case let .postSmallBlind(amount):
            string += " posts small blind of \(amount.moneyString)."
            
        case let .postBigBlind(amount):
            string += " posts big blind of \(amount.moneyString)."
            
        case .fold:
            string += " folds."
            
        case .check:
            string += " checks."

        case let .bet(amount, isAllIn):
            if isAllIn {
                string += " is all in for \(amount.moneyString)."
            } else {
                string += " bets \(amount.moneyString)."
            }
                
        case let .call(amount, isAllIn):
            if isAllIn {
                string += " is all in for \(amount.moneyString)."
            } else {
                string += " calls \(amount.moneyString)."
            }
            
        case .show(let showCards):
            guard let pocketCards: PocketCards = pocketCards[playerHand.player.id] else {
                break
            }
            switch showCards {
            case .first:
                string += " showed \(pocketCards.first.debugDescription)."
                
            case .second:
                string += " showed \(pocketCards.second.debugDescription)."

            case .both:
                string += " showed \(pocketCards.debugDescription)."
            }
        }
        
        return string
    }
    
    private func playerHand(byID playerID: String) -> PlayerHand? {
        (results?.endPlayerHands ?? startingPlayerHands).first(where: { $0.player.id == playerID })
    }
}

private extension [Pot] {
    func debugDescription(getName: (_ id: String) -> String) -> String {
        var description: String = ""
        for (index, pot) in enumerated() {
            description += "\n"
            description += "Pot \(index + 1): \(pot.amount.moneyString)"
            description += "\n"
            description += "Players: \(pot.playerIds.map { getName($0) }.sorted(by: { $0 < $1 }).joined(separator: ", "))"
            description += "\n"
        }
        return description
    }
}

extension [PotResult] {
    func debugDescription(
        getName: (_ id: String) -> String,
        getPocketCards: (_ id: String) -> PocketCards?
    ) -> String {
        var description: String = ""
        
        for (index, potResult) in enumerated() {
            description += "\n"
            description += "Pot \(index + 1): \(potResult.pot.amount.moneyString)"
            
            for winningHand in potResult.winningHands {
                if let pocketCards: PocketCards = getPocketCards(winningHand.playerID) {
                    description += "\n"
                    description += "\(getName(winningHand.playerID)) with pocket cards: \(pocketCards.debugDescription)"
                }
                description += "\n"
                description += "\(winningHand.pokerHand.description)"
                description += "\n"
                description += "----"
            }
        }
        
        return description
    }
}
