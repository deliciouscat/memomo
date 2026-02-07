import Foundation

struct TaskCard: Identifiable, Codable {
    let id: UUID
    var name: String
    var startDate: Date
    var endDate: Date?
    var subTasks: [SubTask]

    var completedCount: Int { subTasks.filter { $0.checkBox }.count }
    var pendingSubTasks: [SubTask] { subTasks.filter { !$0.checkBox } }
    var completedSubTasks: [SubTask] { subTasks.filter { $0.checkBox } }

    static func empty(name: String) -> TaskCard {
        TaskCard(
            id: UUID(),
            name: name,
            startDate: Date(),
            endDate: nil,
            subTasks: []
        )
    }
}
