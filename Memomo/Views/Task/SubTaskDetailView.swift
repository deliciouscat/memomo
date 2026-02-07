import SwiftUI

struct SubTaskDetailView: View {
    @Binding var subTask: SubTask
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
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
                TextField("Subtask name", text: $subTask.name)
                Spacer()
                Button("X") {
                    onDelete()
                }
                .buttonStyle(.borderedProminent)
                .tint(Constants.deleteColor)
            }

            TextField("Description", text: $subTask.description, axis: .vertical)
                .lineLimit(3...6)

            HStack(spacing: 8) {
                DatePicker("Start", selection: $subTask.startDate, displayedComponents: .date)
                    .labelsHidden()
                if subTask.checkBox {
                    DatePicker("End", selection: endDateBinding, displayedComponents: .date)
                        .labelsHidden()
                }
            }
        }
        .padding(8)
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    private var endDateBinding: Binding<Date> {
        Binding<Date>(
            get: { subTask.endDate ?? Date() },
            set: { subTask.endDate = $0 }
        )
    }
}
