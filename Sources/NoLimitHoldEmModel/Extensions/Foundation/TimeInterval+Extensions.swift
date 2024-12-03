import Foundation

extension TimeInterval {
    /// e.g., 2h 20m
    public var hrsAndMinFormat: String {
        let oneHour: TimeInterval = 60 * 60
        var total: TimeInterval = self
        var hours: Int = .zero
        while total >= oneHour {
            total -= oneHour
            hours += 1
        }
        
        var components: [String] = []
        
        if hours > .zero {
            components.append("\(hours)h")
        }
        
        if total.minutes > .zero {
            components.append("\(total.minutes)m")
        }
        
        if components.isEmpty {
            return "0m"
        }
        
        return components.joined(separator: " ")
    }
    
    /// e.g., 2h 20m 30s
    public var hrsMinAndSecFormat: String {
        let oneHour: TimeInterval = 60 * 60
        var total: TimeInterval = self
        var hours: Int = .zero
        while total >= oneHour {
            total -= oneHour
            hours += 1
        }
        
        var components: [String] = []
        
        if hours > .zero {
            components.append("\(hours)h")
        }
        
        let oneMinute: TimeInterval = 60
        var minutes: Int = .zero
        while total >= oneMinute {
            total -= oneMinute
            minutes += 1
        }
        
        if minutes > .zero {
            components.append("\(minutes)m")
        }
        
        if total >= 1 {
            components.append("\(Int(total))s")
        }
        
        if components.isEmpty {
            return "0s"
        }
        
        return components.joined(separator: " ")
    }
    
    /// e.g., 2 hours 20 minutes 30 seconds
    public var hrsMinAndSecLongFormat: String {
        let oneHour: TimeInterval = 60 * 60
        var total: TimeInterval = self
        var hours: Int = .zero
        while total >= oneHour {
            total -= oneHour
            hours += 1
        }
        
        var components: [String] = []
        
        if hours > .zero {
            components.append("\(hours) hour\(hours.pluralS)")
        }
        
        let oneMinute: TimeInterval = 60
        var minutes: Int = .zero
        while total >= oneMinute {
            total -= oneMinute
            minutes += 1
        }
        
        if minutes > .zero {
            components.append("\(minutes) minute\(minutes.pluralS)")
        }
        
        if total >= 1 {
            components.append("\(Int(total)) second\(Int(total).pluralS)")
        }
        
        if components.isEmpty {
            return "0 seconds"
        }
        
        return components.joined(separator: " ")
    }
    
    public var minutes: Int {
        if self == 0 { return 0 }
        return Int(self / 60)
    }
    
    public static var oneHour: TimeInterval {
        60 * 60
    }
    
    public var nanoSeconds: UInt64 {
        UInt64(self * 1_000_000_000)
    }
}
