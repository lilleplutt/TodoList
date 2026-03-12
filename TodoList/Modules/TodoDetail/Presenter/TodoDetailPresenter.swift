import Foundation

final class TodoDetailPresenter {
    
    weak var view: TodoDetailViewInput?
    var interactor: TodoDetailInteractorInput?
    var router: TodoDetailRouterInput?
    
    private var todo: Todo?
    
    init(todo: Todo? = nil) {
        self.todo = todo
    }
}

//MARK: - TodoDetailViewOutput
extension TodoDetailPresenter: TodoDetailViewOutput {
    
    func viewDidLoad() {
        if let todo {
            view?.showTodo(todo)
        }
    }
    
    func didTapSave(title: String, description: String) {
        if let todo {
            interactor?.updateTodo(todo: todo, title: title, description: description)
        } else {
            interactor?.saveTodo(title: title, description: description)
        }
    }
    
    func didTapCancel() {
        router?.dismiss()
    }
}

//MARK: - TodoDetailInteractorOutput
extension TodoDetailPresenter: TodoDetailInteractorOutput {
    
    func didSaveTodo() {
        router?.dismiss()
    }
    
    func didFailWithError(_ error: any Error) {
        view?.showError(error.localizedDescription)
    }
}

