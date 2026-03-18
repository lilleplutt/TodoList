import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private let todosURL = "https://dummyjson.com/todos?limit=30"
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        guard let url = URL(string: todosURL) else { return }
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(TodosResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response.todos.map { $0.toDomain() }))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}

// MARK: - Response Model
private struct TodosResponse: Decodable {
    let todos: [TodoAPI]
}

struct TodoAPI: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
    
    func toDomain() -> Todo {
        return Todo(
            id: self.id,
            title: self.todo,
            description: "",
            isCompleted: self.completed,
            createdAt: Date()
        )
    }
}
