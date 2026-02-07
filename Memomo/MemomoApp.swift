import SwiftUI
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
}

@main
struct MemomoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
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
