import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var activationMonitor: ActivationMonitor

    var body: some View {
        VStack(spacing: 0) {
            MenuBarView()
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(NSColor.windowBackgroundColor))

            Divider()

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
            activationMonitor.startMonitoring(settings: appViewModel.activationSettings)
        }
        .onChange(of: appViewModel.activationSettings) { newValue in
            activationMonitor.startMonitoring(settings: newValue)
            appViewModel.saveSettings()
        }
    }
}
