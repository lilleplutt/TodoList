import UIKit

//MARK: - View
protocol TodoDetailViewInput: AnyObject {
    func showTodo(_ todo: Todo)
}

//MARK: - Presenter
protocol TodoDetailViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String, description: String)
}

//MARK: - Interactor
protocol TodoDetailInteractorInput: AnyObject {
    func saveTodo(title: String, description: String)
    func updateTodo(todo: Todo, title: String, description: String)
}

protocol TodoDetailInteractorOutput: AnyObject {
    func didSaveTodo()
    func didFailWithError(_ error: Error)
}

//MARK: - Router
protocol TodoDetailRouterInput: AnyObject {
    func dismiss()
}

