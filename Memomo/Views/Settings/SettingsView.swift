import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var newBundleId: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activation Settings")
                .font(.headline)

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

            Text("WorkAppList (Bundle IDs)")
                .font(.headline)

            HStack {
                TextField("com.apple.dt.Xcode", text: $newBundleId)
                Button("Add") {
                    let trimmed = newBundleId.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    if !appViewModel.activationSettings.workAppList.contains(trimmed) {
                        appViewModel.activationSettings.workAppList.append(trimmed)
                    }
                    newBundleId = ""
                }
            }

            List {
                ForEach(appViewModel.activationSettings.workAppList, id: \.self) { bundleId in
                    HStack {
                        Text(bundleId)
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
}
