import Foundation

extension String {
    public var duration: TimeInterval? {
        guard !isEmpty else { return nil }
        
        var interval: Double = 0
        
        let parts = components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        
        return interval
    }
    
    
    public func date(withFormat dateFormat: String) -> Date? {
        formatter(for: dateFormat).date(from: self)
    }
    
    /// Date format of "yyyy-MM-dd"
    public static let dayDateFormat: String = "yyyy-MM-dd"
    
    private func formatter(for dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter(dateFormat: dateFormat)
        return formatter
    }
    
    public func formattedForSearch() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    public var url: URL? {
        guard !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        guard let url = URL(string: self) else {
            let cleanString = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            return URL(string: cleanString)
        }
        return url
    }
    
    public func trailingAtFirstSpaceAfter(position: Int) -> String {
        //find first " " after 200
        guard count > position else { return self }
        
        var prefix = self
        prefix.removeLast(count - position)
        var suffix = self
        suffix.removeFirst(position)
        
        let firstSpace = suffix.firstIndex(of: " ") ?? suffix.endIndex
        let finalSuffix = suffix[..<firstSpace]
        
        return prefix + finalSuffix + "..."
    }
    
    public var asJson: Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    public var initials: String {
        let firstLetters = split(separator: " ")
        return firstLetters.compactMap { $0.first?.uppercased() }.joined()
    }
    
    public func stripUrlChars() -> String {
        self
            .replacingOccurrences(of: "/", with: "")
            .replacingOccurrences(of: ":", with: "")
    }
    
    public func stripHTML() -> String {
        replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression,
            range: nil
        )
    }
    
    public var trailingQuestionMarkRemoved: String {
        if last == "?" {
            var updated: String = self
            updated.removeLast()
            return updated
        } else {
            return self
        }
    }
    
    public var capitalizedSentence: String {
        prefix(1).capitalized + dropFirst()
    }
    
    public static var loremPassageStandard: String {
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    }
    
    public var decimal: Decimal? {
        Decimal(string: self)
    }
    
    public var uuid: UUID? {
        UUID(uuidString: self)
    }
}

extension Optional where Wrapped == String {
    public var isNilOrEmpty: Bool {
        guard let self else { return true }
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
