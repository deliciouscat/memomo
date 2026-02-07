import SwiftUI

struct DailyGaugeStackView: View {
    @EnvironmentObject private var activationMonitor: ActivationMonitor

    private let daysToShow = 7
    @State private var hoveredDateKey: String?

    var body: some View {
        let data = recentStats()
        let maxValue = max(data.map { $0.totalSeconds }.max() ?? 1, 1)

        HStack(alignment: .bottom, spacing: 6) {
            ForEach(data, id: \.dateKey) { stat in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Constants.activeColor.opacity(0.7))
                        .frame(height: barHeight(for: stat.totalSeconds, maxValue: maxValue))
                    Text(shortLabel(for: stat.dateKey))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 14)
                .contentShape(Rectangle())
                .onHover { hovering in
                    hoveredDateKey = hovering ? stat.dateKey : nil
                }
                .overlay(alignment: .top) {
                    if hoveredDateKey == stat.dateKey {
                        Text(formatDuration(TimeInterval(stat.totalSeconds)))
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(NSColor.windowBackgroundColor))
                                    .shadow(radius: 2)
                            )
                            .fixedSize()
                            .offset(y: -20)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(NSColor.windowBackgroundColor))
    }

    private func barHeight(for value: Int, maxValue: Int) -> CGFloat {
        let minHeight: CGFloat = 4
        let maxHeight: CGFloat = 36
        let ratio = CGFloat(value) / CGFloat(maxValue)
        return minHeight + (maxHeight - minHeight) * ratio
    }

    private func recentStats() -> [DailyGaugeStat] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let statsByKey = Dictionary(uniqueKeysWithValues: activationMonitor.dailyStats.map { ($0.dateKey, $0) })
        var results: [DailyGaugeStat] = []

        for offset in (0..<daysToShow).reversed() {
            let date = calendar.date(byAdding: .day, value: -offset, to: today) ?? today
            let key = dateKey(for: date, calendar: calendar)
            if let stat = statsByKey[key] {
                results.append(stat)
            } else {
                results.append(DailyGaugeStat(dateKey: key, totalSeconds: 0))
            }
        }
        return results
    }

    private func dateKey(for date: Date, calendar: Calendar) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func shortLabel(for dateKey: String) -> String {
        let parts = dateKey.split(separator: "-")
        if parts.count == 3 {
            return "\(parts[2])"
        }
        return dateKey
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let total = Int(duration)
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        return String(format: "%dh %dm %ds", hours, minutes, seconds)
    }
}
