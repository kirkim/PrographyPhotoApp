//
//  CoreDataFeature.swift
//  PhotoAppCoreData
//
//  Created by 김기림 on 2/4/24.
//

import CoreData

protocol CoreDataFeature {
    associatedtype Model: NSManagedObject
    
    var viewContext: NSManagedObjectContext { get }
    func viewContextSave() throws
    func fetchEntities(id: UUID?, sortKeyPath: ReferenceWritableKeyPath<Model, Date?>?) throws -> [Model]
    
}

extension CoreDataFeature {
    
    var viewContext: NSManagedObjectContext {
        NSPersistentContainer.context
    }
    
    func viewContextSave() throws {
        do {
            try viewContext.save()
        } catch {
            throw CoreDataError.savingFailure
        }
    }
    
    func fetchEntities(id: UUID? = nil, sortKeyPath: ReferenceWritableKeyPath<Model, Date?>? = nil) throws -> [Model] {
        let request = Model.safeFetchRequest()
        if let id = id {
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        } else if let sortKeyPath = sortKeyPath {
            request.sortDescriptors = [NSSortDescriptor(keyPath: sortKeyPath, ascending: false)]
        }
        guard let result = try? viewContext.fetch(request) as? [Model] else {
            throw CoreDataError.fetchFailure("\(Model.entity())")
        }
        
        return result
    }
    
}

fileprivate extension NSManagedObject {
    
    static func safeFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        guard let entityName = entity().name else {
            return fetchRequest()
        }
        
        return NSFetchRequest(entityName: entityName)
    }
    
}
