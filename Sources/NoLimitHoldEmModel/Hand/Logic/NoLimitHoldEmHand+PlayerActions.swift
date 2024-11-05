import Foundation

// MARK: - Post Blinds
extension NoLimitHoldEmHand {
    public mutating func postSmallBlind() throws {
        guard state == .waitingForSmallBlind else {
            throw NoLimitHoldEmHandError.smallBlindAlreadyPosted
        }
        let smallBlindIndex: Int = 0
        let blindBet: Decimal = min(
            blinds.smallBlind,
            playerHands[smallBlindIndex].player.chipCount
        )
        playerHands[smallBlindIndex].currentBet = blindBet
        playerHands[smallBlindIndex].player.chipCount -= blindBet
        
        logDecision(
            .postSmallBlind(amount: blindBet),
            playerHand: playerHands[smallBlindIndex]
        )
        
        state = .waitingForBigBlind
    }
    
    public mutating func postBigBlind() throws {
        guard state == .waitingForBigBlind else {
            throw NoLimitHoldEmHandError.bigBlindAlreadyPosted
        }
        let bigBlindIndex: Int = 1
        let blindBet: Decimal = min(
            blinds.bigBlind,
            playerHands[bigBlindIndex].player.chipCount
        )
        playerHands[bigBlindIndex].currentBet = blindBet
        playerHands[bigBlindIndex].player.chipCount -= blindBet
        
        logDecision(
            .postBigBlind(amount: blindBet),
            playerHand: playerHands[bigBlindIndex]
        )
        
        moveToNextState()
    }
}

// MARK: - Actions
extension NoLimitHoldEmHand {
    public mutating func bet(amount: Decimal) throws {
        guard let currentPlayerHandIndex else {
            throw NoLimitHoldEmHandError.attemptedToActWithNoCurrentPlayer
        }
        
        let validBet: Decimal = min(maxBetForCurrentPlayer, amount)
        
        guard validBet >= minBetForCurrentPlayer else {
            throw NoLimitHoldEmHandError.insufficientBet
        }
        
        if maxOutstandingBet > .zero && validBet > minBetForCurrentPlayer {
            guard validBet >= minRaiseForCurrentPlayer else {
                throw NoLimitHoldEmHandError.insufficientRaise
            }
        }
        
        let didCall: Bool = amount == maxOutstandingBet
        playerHands[currentPlayerHandIndex].currentBet += validBet
        playerHands[currentPlayerHandIndex].player.chipCount -= validBet
        playerHands[currentPlayerHandIndex].hasMovedThisRound = true
        
        let isAllIn: Bool = playerHands[currentPlayerHandIndex].player.chipCount == .zero
        let decision: Log.PlayerAction.Decision =
        if didCall {
            .call(amount: validBet, isAllIn: isAllIn)
        } else {
            .bet(amount: validBet, isAllIn: isAllIn)
        }
        logDecision(
            decision,
            playerHand: playerHands[currentPlayerHandIndex]
        )
        
        moveToNextState()
    }
    
    public mutating func call() throws {
        guard let currentPlayerHand else {
            throw NoLimitHoldEmHandError.attemptedToActWithNoCurrentPlayer
        }
        
        if currentPlayerHand.player.chipCount < maxOutstandingBet {
            try bet(amount: currentPlayerHand.player.chipCount)
        } else {
            try bet(amount: maxOutstandingBet - currentPlayerHand.currentBet)
        }
    }
    
    public mutating func check() throws {
        guard let currentPlayerHandIndex else {
            throw NoLimitHoldEmHandError.attemptedToActWithNoCurrentPlayer
        }
        
        guard canCheck else {
            throw NoLimitHoldEmHandError.triedToCheckWhenThereIsABet
        }
        
        playerHands[currentPlayerHandIndex].hasMovedThisRound = true
        
        logDecision(
            .check,
            playerHand: playerHands[currentPlayerHandIndex]
        )
        
        moveToNextState()
    }
    
    public mutating func fold() throws {
        guard let currentPlayerHand,
              let currentPlayerHandIndex
        else {
            throw NoLimitHoldEmHandError.attemptedToActWithNoCurrentPlayer
        }
        
        guard currentPlayerHand.isAllIn == false,
              currentPlayerHand.currentBet < maxOutstandingBet
        else {
            throw NoLimitHoldEmHandError.triedToFoldWhenThereIsNoBet
        }
        
        playerHands[currentPlayerHandIndex].status = .out
        playerHands[currentPlayerHandIndex].hasMovedThisRound = true
        
        logDecision(
            .fold,
            playerHand: currentPlayerHand
        )
        
        moveToNextState()
    }
}

// MARK: - Logging Helper
extension NoLimitHoldEmHand {
    /// Uses `self.currentPlayerHand` and `self.round`, so make sure those are in the right state
    private mutating func logDecision(
        _ decision: Log.PlayerAction.Decision,
        playerHand: PlayerHand
    ) {
        log.log(
            action: .init(
                playerID: playerHand.player.id,
                decision: decision
            ),
            round: round
        )
    }
}