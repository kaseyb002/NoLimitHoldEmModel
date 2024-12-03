import Foundation

extension Date {
    public func string(_ dateFormat: String) -> String {
        let formatter: DateFormatter = .init(dateFormat: dateFormat)
        return formatter.string(from: self)
    }
    
    public func addYears(_ count: Int) -> Date {
        var dateComponents: DateComponents = .init()
        dateComponents.year = count
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public func addMonths(_ count: Int) -> Date {
        var dateComponents: DateComponents = .init()
        dateComponents.month = count
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public func addWeeks(_ count: Int) -> Date {
        var dateComponents: DateComponents = .init()
        dateComponents.weekOfYear = count
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public func addDays(_ daysToAdd: Int) -> Date {
        var dateComponents: DateComponents = .init()
        dateComponents.day = daysToAdd
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public func addHours(_ hoursToAdd: Int) -> Date {
        var dateComponents: DateComponents = .init()
        dateComponents.hour = hoursToAdd
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public func addMinutes(_ minutesToAdd: Int) -> Date {
        var dateComponents: DateComponents = .init()
        dateComponents.minute = minutesToAdd
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public func addSeconds(_ secondsToAdd: Int) -> Date {
        var dateComponents: DateComponents = .init()
        dateComponents.second = secondsToAdd
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    public var endOfDay: Date {
        startOfDay
            .addDays(1)
            .addSeconds(-1)
    }
}

extension DateFormatter {
    public convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
    
    public convenience init(dateStyle: DateFormatter.Style) {
        self.init()
        self.dateStyle = dateStyle
    }
}
