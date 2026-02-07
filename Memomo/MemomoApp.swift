import SwiftUI

@main
struct MemomoApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var taskViewModel = TaskViewModel()
    @StateObject private var memoViewModel = MemoViewModel()
    @StateObject private var activationMonitor = ActivationMonitor()

    init() {
        DataManager.shared.ensureDataDirectory()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .environmentObject(taskViewModel)
                .environmentObject(memoViewModel)
                .environmentObject(activationMonitor)
        }
        .windowResizability(.contentMinSize)
        .defaultSize(width: 1200, height: 800)
    }
}
