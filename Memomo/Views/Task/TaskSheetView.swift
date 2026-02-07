import SwiftUI

struct TaskSheetView: View {
    @EnvironmentObject private var taskViewModel: TaskViewModel
    @State private var pendingDeleteTaskId: UUID?
    @State private var isDeleteAlertPresented = false

    var body: some View {
        HSplitView {
            taskList
                .frame(minWidth: 260)
            taskDetail
                .frame(minWidth: 420)
        }
    }

    private var taskList: some View {
        List {
            ForEach(taskViewModel.tasks) { task in
                TaskCardRowView(
                    task: task,
                    isSelected: task.id == taskViewModel.selectedTaskId
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    taskViewModel.selectedTaskId = task.id
                }
                .contextMenu {
                    Button("Delete") {
                        pendingDeleteTaskId = task.id
                        isDeleteAlertPresented = true
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .alert("Are You Sure?", isPresented: $isDeleteAlertPresented) {
            Button("Delete", role: .destructive) {
                if let taskId = pendingDeleteTaskId {
                    taskViewModel.deleteTask(id: taskId)
                }
                pendingDeleteTaskId = nil
            }
            Button("Cancel", role: .cancel) {
                pendingDeleteTaskId = nil
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }

    private var taskDetail: some View {
        Group {
            if let selectedId = taskViewModel.selectedTaskId,
               let taskIndex = taskViewModel.tasks.firstIndex(where: { $0.id == selectedId }) {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Task name", text: $taskViewModel.tasks[taskIndex].name)
                        .font(.title2)

                    Text("Pending")
                        .font(.headline)

                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach($taskViewModel.tasks[taskIndex].subTasks) { $subTask in
                                if !subTask.checkBox {
                                    SubTaskDetailView(subTask: $subTask) {
                                        removeSubTask(taskIndex: taskIndex, subTaskId: subTask.id)
                                    }
                                }
                            }
                        }
                    }

                    CompletedDropdownView(subTasks: $taskViewModel.tasks[taskIndex].subTasks) { subTaskId in
                        removeSubTask(taskIndex: taskIndex, subTaskId: subTaskId)
                    }

                    HStack {
                        Button("Add SubTask") {
                            let newSub = SubTask.empty(name: "New SubTask")
                            taskViewModel.tasks[taskIndex].subTasks.append(newSub)
                            taskViewModel.save()
                        }
                        .buttonStyle(.bordered)
                        Spacer()
                    }
                }
                .padding()
            } else {
                Text("Select a task")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private func removeSubTask(taskIndex: Int, subTaskId: UUID) {
        taskViewModel.tasks[taskIndex].subTasks.removeAll { $0.id == subTaskId }
        taskViewModel.save()
    }
}
