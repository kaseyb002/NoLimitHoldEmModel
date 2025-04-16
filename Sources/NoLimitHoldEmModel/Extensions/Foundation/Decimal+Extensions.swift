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
            return Self.moneyFormatter.string(for: self) ?? ""//string(for: self)) ?? ""
        }
        
        var formattedString: String
        if self >= 1_000_000_000_000_000 {
            let quadrillionsAmount: Decimal = self / 1_000_000_000_000_000
            formattedString = Self.quadrillionsFormatter.string(for: quadrillionsAmount) ?? ""
        } else if self >= 1_000_000_000_000 {
            let trillionsAmount: Decimal = self / 1_000_000_000_000
            formattedString = Self.trillionsFormatter.string(for: trillionsAmount) ?? ""
        } else if self >= 1_000_000_000 {
            let billionsAmount: Decimal = self / 1_000_000_000
            formattedString = Self.billionsFormatter.string(for: billionsAmount) ?? ""
        } else if self >= 1_000_000 {
            let millionsAmount: Decimal = self / 1_000_000
            formattedString = Self.millionsFormatter.string(for: millionsAmount) ?? ""
        } else if self >= 1_000 {
            let thousandsAmount: Decimal = self / 1_000
            formattedString = Self.thousandsFormatter.string(for: thousandsAmount) ?? ""
        } else {
            formattedString = Self.moneyFormatter.string(for: self) ?? ""
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
        Self.moneyFormatter.string(for: self) ?? ""
    }
    
    private static let amountFormatter = {
        let formatter: NumberFormatter = .init()
        formatter.maximumFractionDigits = .zero
        return formatter
    }()
    
    public var roundToClosestPenny: Decimal {
        let decimalNumber: NSDecimalNumber = .init(decimal: self)
        let roundingBehavior: NSDecimalNumberHandler = .init(
            roundingMode: .bankers,
            scale: 2,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
        let roundedValue: NSDecimalNumber = decimalNumber.rounding(
            accordingToBehavior: roundingBehavior
        )
        return roundedValue.decimalValue
    }
}
