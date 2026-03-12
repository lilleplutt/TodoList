import UIKit

final class TodoListRouter {
    
    weak var view: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        let router = TodoListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.view = view
        
        return view
    }
}

// MARK: - TodoListRouterInput
extension TodoListRouter: TodoListRouterInput {
    
    func showAddTodo() {
        let detailVC = TodoDetailRouter.createModule(nil)
        view?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func showEditTodo(_ todo: Todo) {
        let detailVC = TodoDetailRouter.createModule(todo)
        view?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
