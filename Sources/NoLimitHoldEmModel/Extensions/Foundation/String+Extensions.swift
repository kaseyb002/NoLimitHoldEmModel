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
    
    public func findMentionText() -> [String] {
        var arr_hasStrings:[String] = []
        let regex = try? NSRegularExpression(pattern: "(#[a-zA-Z0-9_\\p{Arabic}\\p{N}]*)", options: [])
        if let matches = regex?.matches(in: self, options:[], range:NSMakeRange(0, self.count)) {
            for match in matches {
                arr_hasStrings.append(NSString(string: self).substring(with: NSRange(location:match.range.location, length: match.range.length )))
            }
        }
        return arr_hasStrings
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
    
    public var containedEmailAddress: [String] {
        func extractEmailAddresses(from string: String) -> [String] {
            let pattern = #"([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,})"#
            
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                let range = NSRange(location: 0, length: string.utf16.count)
                
                let matches = regex.matches(in: string, options: [], range: range)
                
                return matches.map { match in
                    let nsString = NSString(string: string)
                    return nsString.substring(with: match.range)
                }
            } catch {
                print("Error creating regex: \(error)")
                return []
            }
        }

        return extractEmailAddresses(from: self)
    }
    
    public var hasTagStrings: Bool {
        guard let regex = try? NSRegularExpression(pattern: "<.*>", options: []) else {
            return false
        }
        let matches = regex.matches(in: self, options:[], range: NSMakeRange(0, count))
        return matches.isEmpty == false
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
