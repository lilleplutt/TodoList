import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
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
        let request = TodoEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toDomain() }
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    // MARK: - Save
    func saveTodo(_ todo: Todo) {
        let entity = TodoEntity(context: context)
        entity.id = Int64(todo.id)
        entity.title = todo.title
        entity.desc = todo.description
        entity.createdAt = todo.createdAt
        entity.isCompleted = todo.isCompleted
        saveContext()
    }
    
    // MARK: - Update
    func updateTodo(_ todo: Todo) {
        let request = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", todo.id)
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                entity.title = todo.title
                entity.desc = todo.description
                entity.isCompleted = todo.isCompleted
                saveContext()
            }
        } catch {
            print("Update error: \(error)")
        }
    }
    
    // MARK: - Delete
    func deleteTodo(_ todo: Todo) {
        let request = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", todo.id)
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                context.delete(entity)
                saveContext()
            }
        } catch {
            print("Delete error: \(error)")
        }
    }
    
    // MARK: - Save Context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}

