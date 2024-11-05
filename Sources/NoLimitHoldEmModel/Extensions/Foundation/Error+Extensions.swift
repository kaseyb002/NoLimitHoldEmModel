import Foundation

extension Error {
    public var isMissingFileError: Bool {
        (self as NSError).code == 260
    }
}
