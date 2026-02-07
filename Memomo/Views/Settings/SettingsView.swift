import SwiftUI
import AppKit

struct SettingsView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var newBundleId: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Activation Settings")
                    .font(.headline)
                Spacer()
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }

            HStack {
                Text("Max Gauge")
                Spacer()
                TextField("", value: $appViewModel.activationSettings.maxGauge, format: .number)
                    .frame(width: 120)
            }

            HStack {
                Text("Increase Rate (pt/s)")
                Spacer()
                TextField("", value: $appViewModel.activationSettings.increaseRate, format: .number)
                    .frame(width: 120)
            }

            HStack {
                Text("Decrease Rate (pt/s)")
                Spacer()
                TextField("", value: $appViewModel.activationSettings.decreaseRate, format: .number)
                    .frame(width: 120)
            }

            Divider()

            Text("WorkAppList")
                .font(.headline)

            HStack {
                TextField("Bundle ID (optional)", text: $newBundleId)
                Button("Add") {
                    let trimmed = newBundleId.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    if !appViewModel.activationSettings.workAppList.contains(trimmed) {
                        appViewModel.activationSettings.workAppList.append(trimmed)
                    }
                    newBundleId = ""
                }
            }

            Button("Choose App…") {
                chooseApp()
            }
            .buttonStyle(.bordered)

            List {
                ForEach(appViewModel.activationSettings.workAppList, id: \.self) { bundleId in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(appName(for: bundleId))
                            Text(bundleId)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("Remove") {
                            appViewModel.activationSettings.workAppList.removeAll { $0 == bundleId }
                        }
                        .buttonStyle(.link)
                    }
                }
            }
            .frame(minHeight: 160)

            Spacer()
        }
        .padding(20)
        .frame(width: 480, height: 520)
    }

    private func chooseApp() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.application]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.title = "Choose App"
        if panel.runModal() == .OK, let url = panel.url {
            if let bundle = Bundle(url: url), let bundleId = bundle.bundleIdentifier {
                if !appViewModel.activationSettings.workAppList.contains(bundleId) {
                    appViewModel.activationSettings.workAppList.append(bundleId)
                }
            }
        }
    }

    private func appName(for bundleId: String) -> String {
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) {
            let name = url.deletingPathExtension().lastPathComponent
            return name.isEmpty ? bundleId : name
        }
        return bundleId
    }
}
