import Foundation

extension Int {
    public var pluralS: String { self == 1 ? "" : "s" }
    
    public var haveHasPlural: String { self == 1 ? "has" : "have" }
    
    public var ordinal: String {
        guard self !=  0 else {return "\(self)"}
        return "\(self)" + self.suffix
    }
    
    public var suffix: String {
        let me = self % 100
        switch me {
        case 1:
            return "st"
        case 2:
            return "nd"
        case 3:
            return "rd"
        case 21...99:
            return (me % 10).suffix
        default:
            return "th"
        }
    }
    
    public var minutesStringUpToDaysConcise: String {
        let (days, hours, minutes) = self.minutesToDaysHoursMinutes
        if days > 0 {
            return days.daysString
        } else if hours > 0 {
            return hours.hoursString
        }
        return minutes.minutesString
    }
    
    public var minutes: TimeInterval {
        TimeInterval(self * 60)
    }
    
    public var hours: TimeInterval {
        minutes * 60
    }
    
    public var minutesToDaysHoursMinutes: (Int, Int, Int) {
        (self / 1440, (self % 1440) / 60, (self % 1440) % 60)
    }
    
    public var daysString: String {
        self == 1 ? "\(self) day" : "\(self) days"
    }
    
    public var hoursString: String {
        self == 1 ? "\(self) hour" : "\(self) hours"
    }
    
    public var minutesString: String {
        self == 1 ? "\(self) minute" : "\(self) minutes"
    }
    
    public var secondsString: String {
        self == 1 ? "\(self) second" : "\(self) seconds"
    }
    
    public var minutesStringUpToDaysAbbreviated: String {
        let (days, hours, minutes) = self.minutesToDaysHoursMinutes
        if days > 0 {
            return days.daysStringAbbreviated
        } else if hours > 0 {
            return hours.hoursStringAbbreviated
        }
        return minutes.minutesStringAbbreviated
    }
    
    public var daysStringAbbreviated: String {
        "\(self)d"
    }
    
    public var hoursStringAbbreviated: String {
        "\(self)h"
    }
    
    public var minutesStringAbbreviated: String {
        "\(self)m"
    }
    
    public var secondsStringAbbreviated: String {
        "\(self)s"
    }
    
    public var begOfMinuteInSeconds: Int {
        (self / 60) * 60
    }
        
    public var endOfMinuteInSeconds: Int {
        begOfMinuteInSeconds + 59
    }
    
    public var nilIfZero: Int? {
        self == 0 ? nil : self
    }
}

extension Optional where Wrapped == Int {
    public var string: String? {
        guard let self else {
            return nil
        }
        return "\(self)"
    }
}
