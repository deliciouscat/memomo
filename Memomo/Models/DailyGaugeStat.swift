import Foundation

struct DailyGaugeStat: Identifiable, Codable, Equatable {
    let id: UUID
    var dateKey: String
    var totalSeconds: Int

    init(dateKey: String, totalSeconds: Int) {
        self.id = UUID()
        self.dateKey = dateKey
        self.totalSeconds = totalSeconds
    }
}
