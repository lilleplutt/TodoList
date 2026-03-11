import Foundation

extension TodoEntity {
    func toDomain() -> Todo {
        return Todo(
            id: Int(self.id),
            title: self.title ?? "",
            description: self.desc ?? "",
            isCompleted: self.isCompleted,
            createdAt: self.createdAt ?? Date()
        )
    }
}

