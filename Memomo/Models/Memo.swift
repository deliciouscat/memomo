import Foundation

struct Memo: Identifiable, Codable {
    let id: UUID
    var name: String
    var content: String
    var createdDate: Date
    var modifiedDate: Date

    static func empty(name: String) -> Memo {
        let now = Date()
        return Memo(
            id: UUID(),
            name: name,
            content: "",
            createdDate: now,
            modifiedDate: now
        )
    }
}
