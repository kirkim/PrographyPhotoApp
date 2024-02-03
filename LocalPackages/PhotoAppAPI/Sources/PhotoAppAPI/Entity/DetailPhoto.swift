//
//  File.swift
//  
//
//  Created by 김기림 on 2/3/24.
//

import Foundation

public struct DetailPhoto: Decodable {
    
    let id: String
    let width: Int
    let height: Int
    let url: String
    let tags: [String]
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, urls, tags, description
    }
    
    enum UrlsCodingKeys: String, CodingKey {
        case small
    }
    
    enum TagsCodingKeys: String, CodingKey {
        case title
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        description = try container.decode(String.self, forKey: .description)
        
        let urlsContainer = try container.nestedContainer(keyedBy: UrlsCodingKeys.self, forKey: .urls)
        url = try urlsContainer.decode(String.self, forKey: .small)
        
        var tagsArrayForDecoding = try container.nestedUnkeyedContainer(forKey: .tags)
        var tagsArray = [String]()
        
        while !tagsArrayForDecoding.isAtEnd {
            let tagContainer = try tagsArrayForDecoding.nestedContainer(keyedBy: TagsCodingKeys.self)
            let title = try tagContainer.decode(String.self, forKey: .title)
            tagsArray.append(title)
        }
        
        tags = tagsArray
    }
}

