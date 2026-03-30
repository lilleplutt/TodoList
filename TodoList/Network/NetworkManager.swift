import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private let todosURL = "https://dummyjson.com/todos?limit=30"
    
    enum NetworkError: Error {
        case invalidURL
    }
    
    func fetchTodos() async throws -> [Todo] {
        guard let url = URL(string: todosURL) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(TodosResponse.self, from: data)
        
        return response.todos.map { $0.toDomain() }
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
