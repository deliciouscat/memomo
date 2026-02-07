import SwiftUI

struct TaskCardRowView: View {
    let task: TaskCard
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.name)
                .font(.headline)
                .foregroundStyle(isSelected ? .primary : .secondary)

            Text("Start: \(formatted(date: task.startDate))")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("Completed: \(task.completedCount)/\(task.subTasks.count)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
