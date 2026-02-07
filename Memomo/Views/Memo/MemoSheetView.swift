import SwiftUI

struct MemoSheetView: View {
    @EnvironmentObject private var memoViewModel: MemoViewModel
    @State private var pendingDeleteMemoId: UUID?
    @State private var isDeleteAlertPresented = false

    var body: some View {
        HSplitView {
            memoList
                .frame(minWidth: 240)
            memoDetail
                .frame(minWidth: 420)
        }
    }

    private var memoList: some View {
        List {
            ForEach(memoViewModel.memos) { memo in
                MemoRowView(memo: memo, isSelected: memo.id == memoViewModel.selectedMemoId)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        memoViewModel.selectedMemoId = memo.id
                    }
                    .contextMenu {
                        Button("Delete") {
                            pendingDeleteMemoId = memo.id
                            isDeleteAlertPresented = true
                        }
                    }
            }
        }
        .listStyle(.sidebar)
        .alert("Are You Sure?", isPresented: $isDeleteAlertPresented) {
            Button("Delete", role: .destructive) {
                if let memoId = pendingDeleteMemoId {
                    memoViewModel.deleteMemo(id: memoId)
                }
                pendingDeleteMemoId = nil
            }
            Button("Cancel", role: .cancel) {
                pendingDeleteMemoId = nil
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }

    private var memoDetail: some View {
        Group {
            if let selectedId = memoViewModel.selectedMemoId,
               let memoIndex = memoViewModel.memos.firstIndex(where: { $0.id == selectedId }) {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Memo title", text: $memoViewModel.memos[memoIndex].name)
                        .font(.title2)
                        .onChange(of: memoViewModel.memos[memoIndex].name) { _ in
                            memoViewModel.save()
                        }

                    MarkdownEditorView(content: $memoViewModel.memos[memoIndex].content)
                        .onChange(of: memoViewModel.memos[memoIndex].content) { _ in
                            memoViewModel.updateContent(id: selectedId, content: memoViewModel.memos[memoIndex].content)
                        }
                }
                .padding()
            } else {
                Text("Select a memo")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
