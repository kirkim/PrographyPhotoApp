//
//  BookmarkMetaDataService.swift
//  PhotoAppCoreData
//
//  Created by 김기림 on 2/3/24.
//

import CoreData

fileprivate extension Bookmark {

    var convertedBookmarkData: BookmarkData? {
        guard let id = self.id,
              let createdDate = self.createdAt,
              let photoID = self.photoID
        else {
            return nil
        }
        
        return BookmarkData(
            id: id,
            createdAt: createdDate,
            photoID: photoID
        )
    }
    
}

public final class BookmarkMetaDataService: CoreDataFeature {
    typealias Model = Bookmark

    public init() {}
    
    public func find(by photoID: String) throws -> BookmarkData {
        guard let result = try fetch()?.filter({ $0.photoID == photoID }).first else {
            throw CoreDataError.fetchFailure(#function)
        }
        
        return result
    }
    
    public func fetch(id: UUID? = nil) throws -> [BookmarkData]? {
        return try viewContext.performAndWait {
            let fetchedResults = try fetchEntities(id: id, sortKeyPath: \Model.createdAt)
            do {
                return fetchedResults.compactMap({ $0.convertedBookmarkData })
            }
        }
    }
    
    public func save(by item: BookmarkData) throws {
        try viewContext.performAndWait {
            let newItem = Model(context: viewContext)
            newItem.id = item.id
            newItem.createdAt = item.createdAt
            newItem.photoID = item.photoID
            try viewContextSave()
        }
    }
    
    public func update(by item: BookmarkData) throws {
        try viewContext.performAndWait {
            do {
                let fetchedResults = try fetchEntities(id: item.id)
                if let bookmark = fetchedResults.first {
                    bookmark.id = item.id
                    bookmark.createdAt = item.createdAt
                    bookmark.photoID = item.photoID
                    try viewContextSave()
                }
            } catch {
                throw CoreDataError.updateFailure
            }
        }
    }
    
    public func remove(by id: UUID) throws {
        try viewContext.performAndWait {
            let bookmarks = try fetchEntities(id: id, sortKeyPath: \Model.createdAt)

            for item in bookmarks.reversed() {
                viewContext.delete(item)
            }
            
            do {
                try viewContextSave()
            } catch {
                throw CoreDataError.removeFailure
            }
        }
    }
    
}
