import SwiftUI
import AppKit

struct ContentView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var activationMonitor: ActivationMonitor

    var body: some View {
        VStack(spacing: 0) {
            MenuBarView()
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(Color(NSColor.windowBackgroundColor))

            Divider()

            DailyGaugeStackView()

            Group {
                switch appViewModel.currentSheet {
                case .task:
                    TaskSheetView()
                case .memo:
                    MemoSheetView()
                }
            }
        }
        .sheet(isPresented: $appViewModel.isSettingsPresented) {
            SettingsView()
        }
        .sheet(isPresented: $appViewModel.isSearchPresented) {
            SearchView()
        }
        .onAppear {
            NSApp.activate(ignoringOtherApps: true)
            activationMonitor.startMonitoring(settings: appViewModel.activationSettings)
        }
        .onChange(of: appViewModel.activationSettings) { newValue in
            activationMonitor.startMonitoring(settings: newValue)
            appViewModel.saveSettings()
        }
    }
}
