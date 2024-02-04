//
//  NSPersistentContainer.swift
//
//
//  Created by 김기림 on 2/3/24.
//

import CoreData

extension NSPersistentContainer {
    
    private static let fileName = "PhotoAppDataModel"
    
    private static var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.module.url(forResource: fileName, withExtension: ".momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("CoreData 불러오기 실패")
        }
        
        let container = NSPersistentContainer(name: fileName, managedObjectModel: model)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
        context.automaticallyMergesChangesFromParent = true
        
        return context
    }()
    
}
