import Foundation

final class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskCard] = [] {
        didSet {
            guard !isLoading else { return }
            save()
        }
    }
    @Published var selectedTaskId: UUID?

    private let dataManager: DataManager
    private var isLoading = true

    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        tasks = dataManager.loadTasks()
        selectedTaskId = tasks.first?.id
        isLoading = false
    }

    var selectedTask: TaskCard? {
        tasks.first { $0.id == selectedTaskId }
    }

    func addTask(name: String) {
        let task = TaskCard.empty(name: name)
        tasks.insert(task, at: 0)
        selectedTaskId = task.id
    }

    func deleteTask(id: UUID) {
        tasks.removeAll { $0.id == id }
        if selectedTaskId == id {
            selectedTaskId = tasks.first?.id
        }
    }

    func addSubTask(to taskId: UUID, name: String, description: String) {
        guard let index = tasks.firstIndex(where: { $0.id == taskId }) else { return }
        var subTask = SubTask.empty(name: name)
        subTask.description = description
        tasks[index].subTasks.append(subTask)
    }

    func toggleSubTask(taskId: UUID, subTaskId: UUID) {
        guard let taskIndex = tasks.firstIndex(where: { $0.id == taskId }) else { return }
        guard let subIndex = tasks[taskIndex].subTasks.firstIndex(where: { $0.id == subTaskId }) else { return }
        tasks[taskIndex].subTasks[subIndex].checkBox.toggle()
        if tasks[taskIndex].subTasks[subIndex].checkBox {
            tasks[taskIndex].subTasks[subIndex].endDate = Date()
        } else {
            tasks[taskIndex].subTasks[subIndex].endDate = nil
        }
    }

    func updateSubTask(taskId: UUID, subTask: SubTask) {
        guard let taskIndex = tasks.firstIndex(where: { $0.id == taskId }) else { return }
        guard let subIndex = tasks[taskIndex].subTasks.firstIndex(where: { $0.id == subTask.id }) else { return }
        tasks[taskIndex].subTasks[subIndex] = subTask
    }

    func save() {
        dataManager.saveTasks(tasks)
    }
}
