import Foundation

extension [Blinds] {
    public static var presets: [Blinds] {
        [
            .init(0.01, 0.02),
            .init(0.05, 0.10),
            .init(0.10, 0.20),
            .init(0.25, 0.50),
            .init(0.50, 1.00),
            .init(1, 2),
            .init(2, 4),
            .init(4, 8),
            .init(5, 10),
            .init(10, 20),
            .init(25, 50),
            .init(50, 100),
            .init(75, 150),
            .init(100, 200),
            .init(200, 400),
            .init(300, 600),
            .init(400, 800),
            .init(500, 1_000),
        ]
    }
}

extension Blinds {
    public static func fake() -> Blinds {
        [Blinds].presets.randomElement()!
    }
}
