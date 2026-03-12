import Foundation

final class TodoDetailInteractor {
    
    weak var output: TodoDetailInteractorOutput?
    
    private let coreDataManager = CoreDataManager.shared
}

//MARK: - TodoListInteractorInput
extension TodoDetailInteractor: TodoDetailInteractorInput {
    
    func saveTodo(title: String, description: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            let todo = Todo(
                id: Int(Date().timeIntervalSince1970),
                title: title,
                description: description,
                isCompleted: false,
                createdAt: Date()
            )
            
            self.coreDataManager.saveTodo(todo)
            
            DispatchQueue.main.async {
                self.output?.didSaveTodo()
            }
        }
    }
    
    func updateTodo(todo: Todo, title: String, description: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            var updatedTodo = todo
            updatedTodo.title = title
            updatedTodo.description = description
            
            self.coreDataManager.updateTodo(todo)
            
            DispatchQueue.main.async {
                self.output?.didSaveTodo()
            }
        }
    }
}
