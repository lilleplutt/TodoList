import Foundation

struct Todo: Codable {
    let id: Int
    var title: String
    var description: String
    var isCompleted: Bool
    var createdAt: Date
}
