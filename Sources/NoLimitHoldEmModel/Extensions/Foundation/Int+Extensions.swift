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
    
    public var bigCountText: String {
        let numFormatter = NumberFormatter()

        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "k"),
                                           (100_000.0, 1_000_000.0, "m"),
                                           (100_000_000.0, 1_000_000_000.0, "b")]
                                           // you can add more !
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()

        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1

        return numFormatter.string(from: NSNumber (value:value))!
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
