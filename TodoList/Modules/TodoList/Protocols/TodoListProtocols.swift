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
    func didSearch(_ query: String)
}

//MARK: - Interactor
protocol TodoListInteractorInput: AnyObject {
    func fetchTodos()
    func deleteTodo(_ todo: Todo)
    func searchTodos(_ query: String)
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



