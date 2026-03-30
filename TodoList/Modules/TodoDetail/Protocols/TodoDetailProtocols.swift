import UIKit

//MARK: - View
protocol TodoDetailViewInput: AnyObject {
    func showTodo(_ todo: Todo)
    func showError(_ message: String)
}

//MARK: - Presenter
protocol TodoDetailViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String, description: String)
    func didTapCancel()
}

//MARK: - Interactor
protocol TodoDetailInteractorInput: AnyObject {
    func saveTodo(title: String, description: String) async
    func updateTodo(todo: Todo, title: String, description: String) async
}

protocol TodoDetailInteractorOutput: AnyObject {
    func didSaveTodo()
    func didFailWithError(_ error: Error)
}

//MARK: - Router
protocol TodoDetailRouterInput: AnyObject {
    func dismiss()
}

