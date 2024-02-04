//
//  File.swift
//  
//
//  Created by 김기림 on 2/3/24.
//

import Foundation

public struct DetailPhoto: Decodable {
    
    public let id: String
    public let width: Int
    public let height: Int
    public let url: String
    public let tags: [String]
    public let description: String?
    public let user: String
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, urls, tags, description, user
    }
    
    enum UrlCodingKeys: String, CodingKey {
        case small
    }
    
    enum TagsCodingKeys: String, CodingKey {
        case title
    }
    
    enum UserCodingKeys: String, CodingKey {
        case name
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        
        let urlContainer = try container.nestedContainer(keyedBy: UrlCodingKeys.self, forKey: .urls)
        url = try urlContainer.decode(String.self, forKey: .small)
        
        var tagsArrayForDecoding = try container.nestedUnkeyedContainer(forKey: .tags)
        var tagsArray = [String]()
        
        while !tagsArrayForDecoding.isAtEnd {
            let tagContainer = try tagsArrayForDecoding.nestedContainer(keyedBy: TagsCodingKeys.self)
            let title = try tagContainer.decode(String.self, forKey: .title)
            tagsArray.append(title)
        }
        tags = tagsArray
        
        let userContainer = try container.nestedContainer(keyedBy: UserCodingKeys.self, forKey: .user)
        user = try userContainer.decode(String.self, forKey: .name)
    }
}


