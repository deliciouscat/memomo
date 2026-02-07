import Foundation
import AppKit

final class ActivationMonitor: ObservableObject {
    @Published var isWorkAppActive: Bool = false
    @Published var gaugeValue: Double = 0
    @Published var maxDuration: TimeInterval = 0
    @Published var dailyStats: [DailyGaugeStat] = []

    private var timer: Timer?
    private var maxStartTime: Date?
    private var settings: ActivationSettings = .default
    private let dataManager: DataManager
    private let calendar: Calendar

    init(dataManager: DataManager = .shared, calendar: Calendar = .current) {
        self.dataManager = dataManager
        self.calendar = calendar
        dailyStats = dataManager.loadDailyGaugeStats()
    }

    func startMonitoring(settings: ActivationSettings) {
        self.settings = settings
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        let frontmostId = NSWorkspace.shared.frontmostApplication?.bundleIdentifier
        let isActive = frontmostId.map { settings.workAppList.contains($0) } ?? false

        isWorkAppActive = isActive

        if isActive {
            gaugeValue = min(settings.maxGauge, gaugeValue + settings.increaseRate)
        } else {
            gaugeValue = max(0, gaugeValue - settings.decreaseRate)
        }

        if gaugeValue >= settings.maxGauge {
            if let start = maxStartTime {
                maxDuration = Date().timeIntervalSince(start)
            } else {
                maxStartTime = Date()
            }
            incrementDailyGauge()
        } else {
            maxStartTime = nil
        }
    }

    private func incrementDailyGauge() {
        let key = dateKey(for: Date())
        if let index = dailyStats.firstIndex(where: { $0.dateKey == key }) {
            dailyStats[index].totalSeconds += 1
        } else {
            dailyStats.append(DailyGaugeStat(dateKey: key, totalSeconds: 1))
        }
        dataManager.saveDailyGaugeStats(dailyStats)
    }

    private func dateKey(for date: Date) -> String {
        let startOfDay = calendar.startOfDay(for: date)
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: startOfDay)
    }
}
