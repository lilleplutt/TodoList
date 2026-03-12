import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private func makeBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoList")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData error: \(error)")
            }
        }
        return container
    }()
    
    // MARK: - Fetch
    func fetchTodos() -> [Todo] {
        let backgroundContext = makeBackgroundContext()
        var todos: [Todo] = []
        backgroundContext.performAndWait {
            let request = TodoEntity.fetchRequest()
            do {
                let entities = try backgroundContext.fetch(request)
                todos = entities.map { $0.toDomain() }
            } catch {
                print("Fetch error: \(error)")
            }
        }
        return todos
    }
    
    // MARK: - Save
    func saveTodo(_ todo: Todo) {
        let backgroundContext = makeBackgroundContext()
        backgroundContext.performAndWait {
            let entity = TodoEntity(context: backgroundContext)
            entity.id = Int64(todo.id)
            entity.title = todo.title
            entity.desc = todo.description
            entity.createdAt = todo.createdAt
            entity.isCompleted = todo.isCompleted
            saveContext(backgroundContext)
        }
    }
    
    // MARK: - Update
    func updateTodo(_ todo: Todo) {
        let backgroundContext = makeBackgroundContext()
        backgroundContext.performAndWait {
            let request = TodoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", todo.id)
            do {
                let entities = try backgroundContext.fetch(request)
                if let entity = entities.first {
                    entity.title = todo.title
                    entity.desc = todo.description
                    entity.isCompleted = todo.isCompleted
                    saveContext(backgroundContext)
                }
            } catch {
                print("Update error: \(error)")
            }
        }
    }
    
    // MARK: - Delete
    func deleteTodo(_ todo: Todo) {
        let backgroundContext = makeBackgroundContext()
        backgroundContext.performAndWait {
            let request = TodoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", todo.id)
            do {
                let entities = try backgroundContext.fetch(request)
                if let entity = entities.first {
                    backgroundContext.delete(entity)
                    saveContext(backgroundContext)
                }
            } catch {
                print("Delete error: \(error)")
            }
        }
    }
    
    // MARK: - Save Context
    private func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}
