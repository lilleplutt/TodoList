import UIKit

//MARK: - View
protocol TodoListViewInput: AnyObject {
    func showTodos(_ todos: [Todo])
    func showError(_ message: String)
}

//MARK: - Presenter
protocol TodoListViewOutput: AnyObject {
    func viewDidLoad()
    func didTapAddTodo()
    func didTapEdit(_ todo: Todo)
    func didTapDelete(_ todo: Todo)
    func didToggleCompletion(_ todo: Todo)
    func didSearch(_ query: String)
}

//MARK: - Interactor
protocol TodoListInteractorInput: AnyObject {
    func fetchTodos() async
    func deleteTodo(_ todo: Todo) async
    func toggleTodoCompletion(_ todo: Todo) async
    func searchTodos(_ query: String) async
}

protocol TodoListInteractorOutput: AnyObject {
    func didFetchTodos(_ todos: [Todo])
    func didFailWithError(_ error: Error)
}

//MARK: - Router
protocol TodoListRouterInput: AnyObject {
    func showAddTodo()
    func showEditTodo(_ todo: Todo)
}


