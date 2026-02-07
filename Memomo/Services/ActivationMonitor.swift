import Foundation
import AppKit

final class ActivationMonitor: ObservableObject {
    @Published var isWorkAppActive: Bool = false
    @Published var gaugeValue: Double = 0
    @Published var maxDuration: TimeInterval = 0

    private var timer: Timer?
    private var maxStartTime: Date?
    private var settings: ActivationSettings = .default

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
        } else {
            maxStartTime = nil
        }
    }
}
