import Foundation

final class DataManager {
    static let shared = DataManager()

    private let baseURL = URL(fileURLWithPath: Constants.dataDirectoryPath)
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    private init() {
        encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    func ensureDataDirectory() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: baseURL.path) {
            try? fileManager.createDirectory(at: baseURL, withIntermediateDirectories: true)
        }
    }

    func loadTasks() -> [TaskCard] {
        load([TaskCard].self, from: Constants.tasksFileName) ?? []
    }

    func saveTasks(_ tasks: [TaskCard]) {
        save(tasks, to: Constants.tasksFileName)
    }

    func loadMemos() -> [Memo] {
        load([Memo].self, from: Constants.memosFileName) ?? []
    }

    func saveMemos(_ memos: [Memo]) {
        save(memos, to: Constants.memosFileName)
    }

    func loadSettings() -> ActivationSettings {
        load(ActivationSettings.self, from: Constants.settingsFileName) ?? .default
    }

    func saveSettings(_ settings: ActivationSettings) {
        save(settings, to: Constants.settingsFileName)
    }

    func loadDailyGaugeStats() -> [DailyGaugeStat] {
        load([DailyGaugeStat].self, from: Constants.dailyGaugeFileName) ?? []
    }

    func saveDailyGaugeStats(_ stats: [DailyGaugeStat]) {
        save(stats, to: Constants.dailyGaugeFileName)
    }

    private func load<T: Decodable>(_ type: T.Type, from fileName: String) -> T? {
        ensureDataDirectory()
        let url = baseURL.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? decoder.decode(type, from: data)
    }

    private func save<T: Encodable>(_ value: T, to fileName: String) {
        ensureDataDirectory()
        let url = baseURL.appendingPathComponent(fileName)
        guard let data = try? encoder.encode(value) else { return }
        try? data.write(to: url, options: [.atomic])
    }
}
