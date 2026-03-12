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
                    switch result {
                    case .success(let todos):
                        todos.forEach { self.coreDataManager.saveTodo($0) }
                        self.allTodos = todos
                        self.output?.didFetchTodos(todos)
                        
                    case .failure(let error):
                        self.output?.didFailWithError(error)
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
    
    func searchTodos(_ query: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            if query.isEmpty {
                DispatchQueue.main.async {
                    self.output?.didFetchTodos(self.allTodos)
                }
                return
            }
            
            let filtered = self.allTodos.filter {
                $0.title.lowercased().contains(query.lowercased())
            }
            DispatchQueue.main.async {
                self.output?.didFetchTodos(filtered)
            }
        }
    }
}
