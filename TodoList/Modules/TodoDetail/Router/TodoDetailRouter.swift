import UIKit

final class TodoDetailRouter {
    
    weak var view: UIViewController?
    
    static func createModule(_ todo: Todo? = nil) -> UIViewController {
        let view = TodoDetailViewController()
        let presenter = TodoDetailPresenter(todo: todo)
        let interactor = TodoDetailInteractor()
        let router = TodoDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.view = view
        
        return view
    }
}

//MARK: - TodoDetailRouterInput
extension TodoDetailRouter: TodoDetailRouterInput {
    func dismiss() {
        if let navigationController = view?.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            view?.dismiss(animated: true)
        }
    }
}
