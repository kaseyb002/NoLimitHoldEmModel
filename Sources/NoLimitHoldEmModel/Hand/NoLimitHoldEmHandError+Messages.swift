import Foundation

extension NoLimitHoldEmHandError {
    public var errorMessage: String {
        switch self {
        case .insufficientPlayers:
            "Not enough players to play."
            
        case .blindsNotPosted:
            "Blinds have not been posted."
            
        case .smallBlindAlreadyPosted:
            "Small blind already posted."
            
        case .bigBlindAlreadyPosted:
            "Big blind already posted."
            
        case .insufficientBet:
            "Bet is below the minimum."
            
        case .insufficientRaise:
            "Raise is below the minimum."
            
        case .triedToFoldWhenThereIsNoBet:
            "Cannot fold when there is no bet."
            
        case .triedToCheckWhenThereIsABet:
            "Cannot check when there is a bet."
            
        case .attemptedToActWithNoCurrentPlayer:
            "No current player."
            
        case .playerIDNotFound:
            "Player is not in the hand."
            
        case .playerNotInHand:
            "Player has folded."
        }
    }
}
