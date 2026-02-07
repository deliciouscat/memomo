import SwiftUI

struct TaskSheetView: View {
    @EnvironmentObject private var taskViewModel: TaskViewModel

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
                        taskViewModel.deleteTask(id: task.id)
                    }
                }
            }
        }
        .listStyle(.sidebar)
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
                                    SubTaskDetailView(subTask: $subTask)
                                }
                            }
                        }
                    }

                    CompletedDropdownView(subTasks: $taskViewModel.tasks[taskIndex].subTasks)

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
}
