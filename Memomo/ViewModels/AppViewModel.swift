import Foundation

final class AppViewModel: ObservableObject {
    @Published var currentSheet: SheetType = .task
    @Published var isSettingsPresented: Bool = false
    @Published var isSearchPresented: Bool = false
    @Published var searchQuery: String = ""
    @Published var activationSettings: ActivationSettings = .default

    private let dataManager: DataManager

    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        activationSettings = dataManager.loadSettings()
    }

    func saveSettings() {
        dataManager.saveSettings(activationSettings)
    }
}

enum SheetType {
    case task
    case memo
}
