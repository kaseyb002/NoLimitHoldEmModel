import Foundation

public enum BoolExtensions {
    /// Probability should be between 0 and 1
    public static func random(withProbability probability: Float) -> Bool {
        probability > .random(in: 0...1)
    }
}
