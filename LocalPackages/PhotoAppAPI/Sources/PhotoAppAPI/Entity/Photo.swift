//
//  File.swift
//  
//
//  Created by 김기림 on 2/3/24.
//

import Foundation

public struct Photo: Decodable {
    
    let id: String
    let width: Int
    let height: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, urls
    }
    
    enum UrlsCodingKeys: String, CodingKey {
        case thumb
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        
        let urlsContainer = try container.nestedContainer(keyedBy: UrlsCodingKeys.self, forKey: .urls)
        url = try urlsContainer.decode(String.self, forKey: .thumb)
    }
    
}
