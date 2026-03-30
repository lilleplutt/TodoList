import Foundation

final class TodoListInteractor {
    
    weak var output: TodoListInteractorOutput?
    
    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    
    private var allTodos: [Todo] = []
    private var isFetching = false
}

//MARK: - TodoListInteractorInput
extension TodoListInteractor: TodoListInteractorInput {
    
    func fetchTodos() async {
        if isFetching { return }
        isFetching = true
        defer { isFetching = false }
        
        let savedTodos = await MainActor.run {
            coreDataManager.fetchTodos()
        }
        
        if savedTodos.isEmpty {
            do {
                let todos = try await networkManager.fetchTodos()
                
                await MainActor.run {
                    todos.forEach { coreDataManager.saveTodo($0) }
                }
                
                self.allTodos = todos
                await MainActor.run {
                    self.output?.didFetchTodos(todos)
                }
            } catch {
                await MainActor.run {
                    self.output?.didFailWithError(error)
                }
            }
        } else {
            self.allTodos = savedTodos
            await MainActor.run {
                self.output?.didFetchTodos(savedTodos)
            }
        }
    }
    
    
    func deleteTodo(_ todo: Todo) async {
        await MainActor.run {
            coreDataManager.deleteTodo(todo)
        }
        
        self.allTodos.removeAll { $0.id == todo.id }
        
        await MainActor.run {
            self.output?.didFetchTodos(self.allTodos)
        }
    }
    
    func toggleTodoCompletion(_ todo: Todo) async {
        var updatedTodo = todo
        updatedTodo.isCompleted.toggle()
        
        await MainActor.run {
            coreDataManager.updateTodo(updatedTodo)
        }
        
        if let index = self.allTodos.firstIndex(where: { $0.id == todo.id }) {
            self.allTodos[index] = updatedTodo
        }
        
        await MainActor.run {
            self.output?.didFetchTodos(self.allTodos)
        }
    }
    
    func searchTodos(_ query: String) async {
        let result: [Todo]
        if query.isEmpty {
            result = self.allTodos
        } else {
            let loweredQuery = query.lowercased()
            result = self.allTodos.filter {
                $0.title.lowercased().contains(loweredQuery) ||
                $0.description.lowercased().contains(loweredQuery)
            }
        }
        
        await MainActor.run {
            self.output?.didFetchTodos(result)
        }
    }
    
}
