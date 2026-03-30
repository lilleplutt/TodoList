import Foundation

final class TodoDetailInteractor {
    
    weak var output: TodoDetailInteractorOutput?
    
    private let coreDataManager = CoreDataManager.shared
}

//MARK: - TodoListInteractorInput
extension TodoDetailInteractor: TodoDetailInteractorInput {
    
    func saveTodo(title: String, description: String) async {
        let todo = Todo(
            id: Int(Date().timeIntervalSince1970),
            title: title,
            description: description,
            isCompleted: false,
            createdAt: Date()
        )
        
        await Task.detached(priority: .background) { [coreDataManager] in
            coreDataManager.saveTodo(todo)
        }.value
        
        await MainActor.run {
            self.output?.didSaveTodo()
        }
    }
    
    func updateTodo(todo: Todo, title: String, description: String) async {
        var updatedTodo = todo
        updatedTodo.title = title
        updatedTodo.description = description
        
        await Task.detached(priority: .background) { [coreDataManager] in
            coreDataManager.updateTodo(updatedTodo)
        }.value
        
        await MainActor.run {
            self.output?.didSaveTodo()
        }
    }
}
