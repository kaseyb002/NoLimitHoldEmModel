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
    
    public func yearsFrom(_ date: Date) -> Int{
        (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    
    public func monthsFrom(_ date: Date) -> Int{
        (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    
    public func weeksFrom(_ date: Date) -> Int{
        (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    
    public func daysFrom(_ date: Date) -> Int{
        (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    
    public func hoursFrom(_ date: Date) -> Int{
        (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    
    public func minutesFrom(_ date: Date) -> Int{
        (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    
    public func secondsFrom(_ date: Date) -> Int{
        (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    
    public var hour: Int {
        let calendar = Calendar.current
        let comp = (calendar as NSCalendar).components([.hour], from: self)
        return comp.hour!
    }
    
    public var minute: Int {
        let calendar = Calendar.current
        let comp = (calendar as NSCalendar).components([.minute], from: self)
        return comp.minute!
    }
    
    public var dayInt: Int {
        let calendar = Calendar.current
        let comp = (calendar as NSCalendar).components([.day], from: self)
        return comp.day!
    }
    
    public var yearInt: Int {
        let calendar = Calendar.current
        let comp = (calendar as NSCalendar).components([.year], from: self)
        return comp.year!
    }
    
    /// Different day with same hour and minute
    public func update(toDay day: Date) -> Date {
        let hours: Int = hoursFrom(startOfDay)
        let minutes: Int = minutesFrom(startOfDay.addHours(hours))
        return day.addHours(hours).addMinutes(minutes)
    }
    
    public var agoShort: String {
        if minutesFrom(Date()) == 0 { return "Now" }
        return abs((minutesFrom(Date()))).minutesStringUpToDaysAbbreviated
    }

    public var ago: String {
        if minutesFrom(Date()) == 0 { return "Just now"}
        return abs((minutesFrom(Date()))).minutesStringUpToDaysConcise + " ago"
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
