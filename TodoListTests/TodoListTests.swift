//
//  TodoListTests.swift
//  TodoListTests
//
//  Created by Alina on 11/03/2026.
//

import Testing
@testable import TodoList

struct TodoListPresenterTests {
    
    private final class MockView: TodoListViewInput {
        var shownTodos: [Todo] = []
        var shownError: String?
        
        func showTodos(_ todos: [Todo]) {
            shownTodos = todos
        }
        
        func showError(_ message: String) {
            shownError = message
        }
    }
    
    private final class MockInteractor: TodoListInteractorInput {
        private(set) var fetchTodosCalled = false
        private(set) var deletedTodo: Todo?
        private(set) var lastSearchQuery: String?
        
        func fetchTodos() {
            fetchTodosCalled = true
        }
        
        func deleteTodo(_ todo: Todo) {
            deletedTodo = todo
        }
        
        func searchTodos(_ query: String) {
            lastSearchQuery = query
        }
    }
    
    private final class MockRouter: TodoListRouterInput {
        private(set) var didShowAddTodo = false
        private(set) var editedTodo: Todo?
        
        func showAddTodo() {
            didShowAddTodo = true
        }
        
        func showEditTodo(_ todo: Todo) {
            editedTodo = todo
        }
    }
    
    @Test
    func viewDidLoad_triggersFetch() {
        let presenter = TodoListPresenter()
        let interactor = MockInteractor()
        presenter.interactor = interactor
        
        presenter.viewDidLoad()
        
        #expect(interactor.fetchTodosCalled == true)
    }
    
    @Test
    func didTapAddTodo_routesToAdd() {
        let presenter = TodoListPresenter()
        let router = MockRouter()
        presenter.router = router
        
        presenter.didTapAddTodo()
        
        #expect(router.didShowAddTodo == true)
    }
    
    @Test
    func didTapEdit_routesToEditWithTodo() {
        let presenter = TodoListPresenter()
        let router = MockRouter()
        presenter.router = router
        
        let todo = Todo(id: 1, title: "Test", description: "", isCompleted: false, createdAt: Date())
        presenter.didTapEdit(todo)
        
        #expect(router.editedTodo?.id == todo.id)
    }
    
    @Test
    func didTapDelete_asksInteractorToDelete() {
        let presenter = TodoListPresenter()
        let interactor = MockInteractor()
        presenter.interactor = interactor
        
        let todo = Todo(id: 2, title: "Delete", description: "", isCompleted: false, createdAt: Date())
        presenter.didTapDelete(todo)
        
        #expect(interactor.deletedTodo?.id == todo.id)
    }
    
    @Test
    func didSearch_forwardsQueryToInteractor() {
        let presenter = TodoListPresenter()
        let interactor = MockInteractor()
        presenter.interactor = interactor
        
        presenter.didSearch("query")
        
        #expect(interactor.lastSearchQuery == "query")
    }
    
    @Test
    func didFetchTodos_updatesView() {
        let presenter = TodoListPresenter()
        let view = MockView()
        presenter.view = view
        
        let todos = [
            Todo(id: 1, title: "One", description: "", isCompleted: false, createdAt: Date()),
            Todo(id: 2, title: "Two", description: "", isCompleted: true, createdAt: Date())
        ]
        
        presenter.didFetchTodos(todos)
        
        #expect(view.shownTodos.count == 2)
    }
    
    @Test
    func didFailWithError_showsErrorOnView() {
        let presenter = TodoListPresenter()
        let view = MockView()
        presenter.view = view
        
        struct SampleError: Error {}
        presenter.didFailWithError(SampleError())
        
        #expect(view.shownError != nil)
    }
}

struct TodoDetailPresenterTests {
    
    private final class MockView: TodoDetailViewInput {
        var shownTodo: Todo?
        var shownError: String?
        
        func showTodo(_ todo: Todo) {
            shownTodo = todo
        }
        
        func showError(_ message: String) {
            shownError = message
        }
    }
    
    private final class MockInteractor: TodoDetailInteractorInput {
        private(set) var savedTitle: String?
        private(set) var savedDescription: String?
        private(set) var updatedTodo: Todo?
        
        func saveTodo(title: String, description: String) {
            savedTitle = title
            savedDescription = description
        }
        
        func updateTodo(todo: Todo, title: String, description: String) {
            updatedTodo = Todo(
                id: todo.id,
                title: title,
                description: description,
                isCompleted: todo.isCompleted,
                createdAt: todo.createdAt
            )
        }
    }
    
    private final class MockRouter: TodoDetailRouterInput {
        private(set) var didDismiss = false
        
        func dismiss() {
            didDismiss = true
        }
    }
    
    @Test
    func viewDidLoad_withTodo_showsTodo() {
        let todo = Todo(id: 1, title: "Existing", description: "Desc", isCompleted: false, createdAt: Date())
        let presenter = TodoDetailPresenter(todo: todo)
        let view = MockView()
        presenter.view = view
        
        presenter.viewDidLoad()
        
        #expect(view.shownTodo?.id == todo.id)
    }
    
    @Test
    func didTapSave_withoutExistingTodo_createsNew() {
        let presenter = TodoDetailPresenter(todo: nil)
        let interactor = MockInteractor()
        presenter.interactor = interactor
        
        presenter.didTapSave(title: "New", description: "Desc")
        
        #expect(interactor.savedTitle == "New")
        #expect(interactor.savedDescription == "Desc")
    }
    
    @Test
    func didTapSave_withExistingTodo_updatesIt() {
        let todo = Todo(id: 1, title: "Old", description: "Old desc", isCompleted: false, createdAt: Date())
        let presenter = TodoDetailPresenter(todo: todo)
        let interactor = MockInteractor()
        presenter.interactor = interactor
        
        presenter.didTapSave(title: "Updated", description: "Updated desc")
        
        #expect(interactor.updatedTodo?.title == "Updated")
        #expect(interactor.updatedTodo?.description == "Updated desc")
    }
    
    @Test
    func didSaveTodo_dismissesModule() {
        let presenter = TodoDetailPresenter()
        let router = MockRouter()
        presenter.router = router
        
        presenter.didSaveTodo()
        
        #expect(router.didDismiss == true)
    }
}
