import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var taskViewModel: TaskViewModel
    @EnvironmentObject private var memoViewModel: MemoViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Search", text: $appViewModel.searchQuery)
                .textFieldStyle(.roundedBorder)

            if appViewModel.currentSheet == .task {
                List(filteredTasks) { task in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.name)
                        Text("SubTasks: \(matchingSubTaskCount(for: task))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                List(filteredMemos) { memo in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(memo.name)
                        Text(snippet(from: memo.content))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(20)
        .frame(width: 520, height: 480)
    }

    private var filteredTasks: [TaskCard] {
        let query = appViewModel.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return taskViewModel.tasks }
        return taskViewModel.tasks.filter { task in
            task.name.localizedCaseInsensitiveContains(query) ||
            task.subTasks.contains { $0.name.localizedCaseInsensitiveContains(query) || $0.description.localizedCaseInsensitiveContains(query) }
        }
    }

    private var filteredMemos: [Memo] {
        let query = appViewModel.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return memoViewModel.memos }
        return memoViewModel.memos.filter { memo in
            memo.name.localizedCaseInsensitiveContains(query) ||
            memo.content.localizedCaseInsensitiveContains(query)
        }
    }

    private func matchingSubTaskCount(for task: TaskCard) -> Int {
        let query = appViewModel.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return task.subTasks.count }
        return task.subTasks.filter { sub in
            sub.name.localizedCaseInsensitiveContains(query) ||
            sub.description.localizedCaseInsensitiveContains(query)
        }.count
    }

    private func snippet(from content: String) -> String {
        let line = content.split(separator: "\n").first.map(String.init) ?? ""
        return line.isEmpty ? "(empty)" : line
    }
}
