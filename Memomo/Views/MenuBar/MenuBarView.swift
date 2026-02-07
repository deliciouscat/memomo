import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var taskViewModel: TaskViewModel
    @EnvironmentObject private var memoViewModel: MemoViewModel
    @EnvironmentObject private var activationMonitor: ActivationMonitor

    var body: some View {
        HStack(spacing: 12) {
            Button(action: addItem) {
                Text("➕")
            }
            .buttonStyle(.plain)

            Button(action: toggleSheet) {
                Text(appViewModel.currentSheet == .task ? "📝" : "🛞")
            }
            .buttonStyle(.plain)

            Button(action: { appViewModel.isSearchPresented = true }) {
                Text("🔎")
            }
            .buttonStyle(.plain)

            Circle()
                .fill(activationMonitor.isWorkAppActive ? Constants.activeColor : Constants.inactiveColor)
                .frame(width: 10, height: 10)
                .help("Activation status")

            ProgressView(value: activationMonitor.gaugeValue, total: max(1, appViewModel.activationSettings.maxGauge))
                .frame(width: 120)

            Text(format(duration: activationMonitor.maxDuration))
                .font(.caption)
                .frame(minWidth: 70, alignment: .leading)

            Spacer()

            Button(action: { appViewModel.isSettingsPresented = true }) {
                Text("⚙️")
            }
            .buttonStyle(.plain)
        }
    }

    private func addItem() {
        switch appViewModel.currentSheet {
        case .task:
            taskViewModel.addTask(name: "New Task")
        case .memo:
            memoViewModel.addMemo(name: "New Memo")
        }
    }

    private func toggleSheet() {
        appViewModel.currentSheet = appViewModel.currentSheet == .task ? .memo : .task
    }

    private func format(duration: TimeInterval) -> String {
        let total = Int(duration)
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        return String(format: "%dh %dm %ds", hours, minutes, seconds)
    }
}
