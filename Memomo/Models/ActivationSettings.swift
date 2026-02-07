import Foundation

struct ActivationSettings: Codable, Equatable {
    var maxGauge: Double
    var increaseRate: Double
    var decreaseRate: Double
    var workAppList: [String]

    static let `default` = ActivationSettings(
        maxGauge: 100,
        increaseRate: 1,
        decreaseRate: 0.5,
        workAppList: ["com.apple.dt.Xcode"]
    )
}
