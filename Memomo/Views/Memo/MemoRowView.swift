import SwiftUI

struct MemoRowView: View {
    let memo: Memo
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(memo.name)
                .font(.headline)
                .foregroundStyle(isSelected ? .primary : .secondary)

            Text("Updated: \(formatted(date: memo.modifiedDate))")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
