import Foundation

final class MemoViewModel: ObservableObject {
    @Published var memos: [Memo] = [] {
        didSet {
            guard !isLoading else { return }
            save()
        }
    }
    @Published var selectedMemoId: UUID?

    private let dataManager: DataManager
    private var isLoading = true

    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        memos = dataManager.loadMemos()
        selectedMemoId = memos.first?.id
        isLoading = false
    }

    var selectedMemo: Memo? {
        memos.first { $0.id == selectedMemoId }
    }

    func addMemo(name: String) {
        let memo = Memo.empty(name: name)
        memos.insert(memo, at: 0)
        selectedMemoId = memo.id
    }

    func deleteMemo(id: UUID) {
        memos.removeAll { $0.id == id }
        if selectedMemoId == id {
            selectedMemoId = memos.first?.id
        }
    }

    func updateContent(id: UUID, content: String) {
        guard let index = memos.firstIndex(where: { $0.id == id }) else { return }
        memos[index].content = content
        memos[index].modifiedDate = Date()
    }

    func updateName(id: UUID, name: String) {
        guard let index = memos.firstIndex(where: { $0.id == id }) else { return }
        memos[index].name = name
        memos[index].modifiedDate = Date()
    }

    func save() {
        dataManager.saveMemos(memos)
    }
}
