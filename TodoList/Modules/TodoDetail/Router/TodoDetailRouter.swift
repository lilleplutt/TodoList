import UIKit

final class TodoDetailRouter {
    
    weak var view: UIViewController?
    
    func createModule() -> UIViewController {
        let view = TodoDetailViewController()
        let presenter = TodoDetailPresenter()
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
        view?.dismiss(animated: true)
    }
}

