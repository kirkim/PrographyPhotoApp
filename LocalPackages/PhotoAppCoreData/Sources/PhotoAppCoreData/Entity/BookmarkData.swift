//
//  File.swift
//  
//
//  Created by 김기림 on 2/4/24.
//

import Foundation

public struct BookmarkData {
    
    public let id: UUID
    public let createdAt: Date
    public let photoID: String
    
    public init(id: UUID, createdAt: Date, photoID: String) {
        self.id = id
        self.createdAt = createdAt
        self.photoID = photoID
    }
    
}
