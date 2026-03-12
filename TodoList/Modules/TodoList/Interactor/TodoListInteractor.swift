import Foundation

final class TodoListInteractor {
    
    weak var output: TodoListInteractorOutput?
    
    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    
    private var allTodos: [Todo] = []
}

//MARK: - TodoListInteractorInput
extension TodoListInteractor: TodoListInteractorInput {
    
    func fetchTodos() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            let savedTodos = self.coreDataManager.fetchTodos()
            
            if savedTodos.isEmpty {
                self.networkManager.fetchTodos { result in
                    DispatchQueue.global(qos: .background).async { [weak self] in
                        guard let self else { return }

                        switch result {
                        case .success(let todos):
                            todos.forEach { self.coreDataManager.saveTodo($0) }
                            self.allTodos = todos
                            DispatchQueue.main.async {
                                self.output?.didFetchTodos(todos)
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.output?.didFailWithError(error)
                            }
                        }
                    }
                }
            } else {
                self.allTodos = savedTodos
                DispatchQueue.main.async {
                    self.output?.didFetchTodos(savedTodos)
                }
            }
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else {return }
            
            self.coreDataManager.deleteTodo(todo)
            self.allTodos.removeAll { $0.id == todo.id }
            DispatchQueue.main.async {
                self.output?.didFetchTodos(self.allTodos)
            }
        }
    }

    func toggleTodoCompletion(_ todo: Todo) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }

            var updatedTodo = todo
            updatedTodo.isCompleted.toggle()
            self.coreDataManager.updateTodo(updatedTodo)

            if let index = self.allTodos.firstIndex(where: { $0.id == todo.id }) {
                self.allTodos[index] = updatedTodo
            }

            DispatchQueue.main.async {
                self.output?.didFetchTodos(self.allTodos)
            }
        }
    }
    
    func searchTodos(_ query: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            if query.isEmpty {
                DispatchQueue.main.async {
                    self.output?.didFetchTodos(self.allTodos)
                }
                return
            }
            
            let loweredQuery = query.lowercased()
            let filtered = self.allTodos.filter {
                $0.title.lowercased().contains(loweredQuery) ||
                $0.description.lowercased().contains(loweredQuery)
            }
            DispatchQueue.main.async {
                self.output?.didFetchTodos(filtered)
            }
        }
    }
}
