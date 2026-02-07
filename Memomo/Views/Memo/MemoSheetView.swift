import SwiftUI

struct MemoSheetView: View {
    @EnvironmentObject private var memoViewModel: MemoViewModel

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
                            memoViewModel.deleteMemo(id: memo.id)
                        }
                    }
            }
        }
        .listStyle(.sidebar)
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
