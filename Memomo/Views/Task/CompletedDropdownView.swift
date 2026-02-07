import SwiftUI

struct CompletedDropdownView: View {
    @Binding var subTasks: [SubTask]
    @State private var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup("Completed", isExpanded: $isExpanded) {
            VStack(spacing: 6) {
                ForEach($subTasks) { $subTask in
                    if subTask.checkBox {
                        SubTaskAbstractRow(subTask: $subTask)
                    }
                }
            }
            .padding(.top, 4)
        }
        .padding(.top, 8)
    }
}

private struct SubTaskAbstractRow: View {
    @Binding var subTask: SubTask

    var body: some View {
        HStack {
            Toggle("", isOn: $subTask.checkBox)
                .labelsHidden()
                .onChange(of: subTask.checkBox) { newValue in
                    if newValue {
                        subTask.endDate = Date()
                    } else {
                        subTask.endDate = nil
                    }
                }
            Text(subTask.name)
            Spacer()
            Text(durationText())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(6)
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    private func durationText() -> String {
        guard let endDate = subTask.endDate else { return "-" }
        let interval = endDate.timeIntervalSince(subTask.startDate)
        let total = max(0, Int(interval))
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        return String(format: "%dh %dm %ds", hours, minutes, seconds)
    }
}
