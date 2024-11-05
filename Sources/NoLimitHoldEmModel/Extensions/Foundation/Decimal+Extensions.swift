import Foundation

extension Decimal {
    private static let moneyFormatter = {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private static let millionsFormatter = {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = "M"
        return formatter
    }()
    
    private static let billionsFormatter = {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = "B"
        return formatter
    }()
    
    private static let trillionsFormatter = {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = "T"
        return formatter
    }()
    
    private static let quadrillionsFormatter = {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = "Q"
        return formatter
    }()
    
    private static let thousandsFormatter = {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = "K"
        return formatter
    }()
    
    /// e.g.,  $1.23M, $234.56K, $567.89
    public var moneyString: String {
        if self == .zero {
            return Self.moneyFormatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
        }
        
        var formattedString: String
        if self >= 1_000_000_000_000_000 {
            let quadrillionsAmount: Decimal = self / 1_000_000_000_000_000
            formattedString = Self.quadrillionsFormatter.string(from: NSDecimalNumber(decimal: quadrillionsAmount)) ?? ""
        } else if self >= 1_000_000_000_000 {
            let trillionsAmount: Decimal = self / 1_000_000_000_000
            formattedString = Self.trillionsFormatter.string(from: NSDecimalNumber(decimal: trillionsAmount)) ?? ""
        } else if self >= 1_000_000_000 {
            let billionsAmount: Decimal = self / 1_000_000_000
            formattedString = Self.billionsFormatter.string(from: NSDecimalNumber(decimal: billionsAmount)) ?? ""
        } else if self >= 1_000_000 {
            let millionsAmount: Decimal = self / 1_000_000
            formattedString = Self.millionsFormatter.string(from: NSDecimalNumber(decimal: millionsAmount)) ?? ""
        } else if self >= 1_000 {
            let thousandsAmount: Decimal = self / 1_000
            formattedString = Self.thousandsFormatter.string(from: NSDecimalNumber(decimal: thousandsAmount)) ?? ""
        } else {
            formattedString = Self.moneyFormatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
        }
        
        if formattedString.hasSuffix(".00") {
            formattedString = String(formattedString.dropLast(3))
        } else if formattedString.hasSuffix(".00K") {
            formattedString = String(formattedString.dropLast(4)) + "K"
        } else if formattedString.hasSuffix(".00M") {
            formattedString = String(formattedString.dropLast(4)) + "M"
        } else if formattedString.hasSuffix(".00B") {
            formattedString = String(formattedString.dropLast(4)) + "B"
        } else if formattedString.hasSuffix(".00T") {
            formattedString = String(formattedString.dropLast(4)) + "T"
        } else if formattedString.hasSuffix(".00Q") {
            formattedString = String(formattedString.dropLast(4)) + "Q"
        }
        
        return formattedString
    }
    
    /// e.g.,  $1,234,567.89
    public var exactAmountString: String {
        Self.moneyFormatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
    }
    
    private static let amountFormatter = {
        let formatter: NumberFormatter = .init()
        formatter.maximumFractionDigits = .zero
        return formatter
    }()
    
    public var float: Float {
        NSDecimalNumber(decimal: self).floatValue
    }
    
    public var double: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }
    
    public static func random(in range: ClosedRange<Double>) -> Decimal {
        .init(floatLiteral: .random(in: range))
    }
}
