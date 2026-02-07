import Foundation

struct SubTask: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var startDate: Date
    var endDate: Date?
    var checkBox: Bool

    static func empty(name: String) -> SubTask {
        SubTask(
            id: UUID(),
            name: name,
            description: "",
            startDate: Date(),
            endDate: nil,
            checkBox: false
        )
    }
}
