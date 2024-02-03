//
//  File.swift
//  
//
//  Created by 김기림 on 2/3/24.
//

import Foundation

public struct Photo: Decodable {
    
    public let id: String
    public let width: CGFloat
    public let height: CGFloat
    public let url: String
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, urls
    }
    
    enum UrlsCodingKeys: String, CodingKey {
        case thumb
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(CGFloat.self, forKey: .width)
        height = try container.decode(CGFloat.self, forKey: .height)
        
        let urlsContainer = try container.nestedContainer(keyedBy: UrlsCodingKeys.self, forKey: .urls)
        url = try urlsContainer.decode(String.self, forKey: .thumb)
    }
    
}
