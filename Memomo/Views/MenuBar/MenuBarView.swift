import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var taskViewModel: TaskViewModel
    @EnvironmentObject private var memoViewModel: MemoViewModel
    @EnvironmentObject private var activationMonitor: ActivationMonitor
    @State private var pulse: Bool = false
    private let iconFont: Font = .title2

    var body: some View {
        HStack(spacing: 18) {
            Button(action: addItem) {
                Text("➕")
                    .font(iconFont)
            }
            .buttonStyle(.plain)

            Button(action: toggleSheet) {
                Text(appViewModel.currentSheet == .task ? "📝" : "🛞")
                    .font(iconFont)
            }
            .buttonStyle(.plain)

            Button(action: { appViewModel.isSearchPresented = true }) {
                Text("🔎")
                    .font(iconFont)
            }
            .buttonStyle(.plain)

            Circle()
                .fill(activationMonitor.isWorkAppActive ? Constants.activeColor : Constants.inactiveColor)
                .frame(width: 16, height: 16)
                .scaleEffect(activationMonitor.isWorkAppActive ? (pulse ? 1.08 : 0.95) : 1.0)
                .opacity(activationMonitor.isWorkAppActive ? (pulse ? 0.65 : 1.0) : 1.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                        pulse = true
                    }
                }
                .onChange(of: activationMonitor.isWorkAppActive) { isActive in
                    if !isActive {
                        pulse = false
                    } else {
                        withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                            pulse = true
                        }
                    }
                }
                .help("Activation status")

            ProgressView(value: activationMonitor.gaugeValue, total: max(1, appViewModel.activationSettings.maxGauge))
                .frame(width: 180)

            Text(format(duration: activationMonitor.maxDuration))
                .font(.callout)
                .frame(minWidth: 90, alignment: .leading)

            Spacer()

            Button(action: { appViewModel.isSettingsPresented = true }) {
                Text("⚙️")
                    .font(iconFont)
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
