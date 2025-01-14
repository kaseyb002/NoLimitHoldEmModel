import Foundation

public enum NoLimitHoldEmHandError: Error {
    case insufficientPlayers
    case blindsNotPosted
    case smallBlindAlreadyPosted
    case bigBlindAlreadyPosted
    case insufficientBet
    case insufficientRaise
    case triedToFoldWhenThereIsNoBet
    case triedToCheckWhenThereIsABet
    case attemptedToActWithNoCurrentPlayer
    case playerIDNotFound
    case playerNotInHand
}
