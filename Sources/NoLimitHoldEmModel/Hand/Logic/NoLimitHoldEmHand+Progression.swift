import Foundation

// MARK: - Progressing Rounds
extension NoLimitHoldEmHand {
    public mutating func progressRoundIfReady() {
        guard isReadyForNextRound else {
            return
        }
        
        collectBets()
        
        switch round {
        case .preflop:
            round = .flop
            
        case .flop:
            round = .turn
            
        case .turn:
            round = .river
            
        case .river:
            completeHand()
            return
        }
        
        let activePlayersNotAllInCount: Int = activePlayerHands
            .filter { $0.isAllIn == false }
            .count
        if activePlayersNotAllInCount <= 1 {
            collectBets()
            completeHand()
        } else {
            resetPlayersHaveMoved()
            resetCurrentPlayerForNextRound()
        }
    }
}

// MARK: - Move to Next Player
extension NoLimitHoldEmHand {
    public mutating func moveToNextState() {
        guard activePlayerHands.count > 1 else {
            collectBets()
            completeHand()
            return
        }
        
        switch state {
        case .waitingForSmallBlind:
            state = .waitingForBigBlind
            
        case .waitingForBigBlind, .waitingForPlayerToAct:
            if isReadyForNextRound {
                state = .waitingToProgressToNextRound
                moveToNextState()
            } else {
                findNextPlayerWhoNeedsToCallBet()
            }
            
        case .waitingToProgressToNextRound:
            if autoProgress.autoMoveToNextRound {
                progressRoundIfReady()
            }
            
        case .handComplete:
            break
        }
    }
    
    private mutating func findNextPlayerWhoNeedsToCallBet() {
        guard let currentPlayerHandIndex else {
            return
        }
        
        defer {
            autoCheckIfCurrentPlayerIsAllIn()
        }
        
        var index: Int = currentPlayerHandIndex + 1
        
        while index != currentPlayerHandIndex {
            if index >= playerHands.count {
                index = .zero
            }
            
            defer {
                index += 1
            }
            
            let playerHand: PlayerHand = playerHands[index]
            
            if playerHand.status == .out {
                continue
            }
            
            if playerHand.isAllIn {
                continue
            }
            
            if playerHand.hasMovedThisRound == false {
                state = .waitingForPlayerToAct(playerIndex: index)
                return
            }
            
            if playerHand.currentBet == maxOutstandingBet {
                state = .waitingForPlayerToAct(playerIndex: index)
                return
            }
            
            if playerHand.currentBet < maxOutstandingBet {
                state = .waitingForPlayerToAct(playerIndex: index)
                return
            }
        }
    }
    
    internal mutating func resetCurrentPlayerForNextRound() {
        defer {
            autoCheckIfCurrentPlayerIsAllIn()
        }
        
        for (index, player) in playerHands.enumerated() {
            if player.status == .in {
                state = .waitingForPlayerToAct(playerIndex: index)
                return
            }
        }
    }
    
    internal mutating func resetPlayersHaveMoved() {
        for (index, _) in playerHands.enumerated() {
            playerHands[index].hasMovedThisRound = false
        }
    }
    
    private mutating func autoCheckIfCurrentPlayerIsAllIn() {
        guard let currentPlayerHand,
              currentPlayerHand.isAllIn,
              state != .handComplete
        else {
            return
        }
        try? check()
    }
    
    internal var isReadyForNextRound: Bool {
        activePlayerHands.allSatisfy({ player in
            if player.isAllIn {
                return true
            }
            
            guard player.hasMovedThisRound else {
                return false
            }
            
            if player.currentBet == maxOutstandingBet {
                return true
            }
            
            return false
        })
    }
}

