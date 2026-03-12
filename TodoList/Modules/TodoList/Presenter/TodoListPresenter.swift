import Foundation

final class TodoListPresenter {
    
    weak var view: TodoListViewInput?
    var interactor: TodoListInteractorInput?
    var router: TodoListRouterInput?
    
}

//MARK: - TodoListViewOutput
extension TodoListPresenter: TodoListViewOutput {
    
    func viewDidLoad() {
        interactor?.fetchTodos()
    }
    
    func didTapAddTodo() {
        router?.showAddTodo()
    }
    
    func didTapEdit(_ todo: Todo) {
        router?.showEditTodo(todo)
    }
    
    func didTapDelete(_ todo: Todo) {
        interactor?.deleteTodo(todo)
    }
    
    func didSearch(_ query: String) {
        interactor?.searchTodos(query)
    }
}

//MARK: - TodoListInteractorOutput
extension TodoListPresenter: TodoListInteractorOutput {
    
    func didFetchTodos(_ todos: [Todo]) {
        view?.showTodos(todos)
    }
    
    func didFailWithError(_ error: any Error) {
        view?.showError(error.localizedDescription)
    }
}

