//
//  PhotoNetworkService.swift
//  PhotoAppAPI
//
//  Created by 김기림 on 2/3/24.
//

import Foundation

public final class PhotoNetworkService {
    
    public init() {}
    
    public func requestPhotos(page: Int) async -> [Photo]? {
        guard 
            let urlRequest = PhotoAppAPI.list(page: page).urlRequest,
            let (data, _) = try? await URLSession.shared.data(for: urlRequest)
        else {
            return nil
        }
        guard let result = try? JSONDecoder().decode([Photo].self, from: data) else {
            return nil
        }
        
        return result
    }
    
    public func requestRandomPhoto() async -> Photo? {
        guard
            let urlRequest = PhotoAppAPI.random.urlRequest,
            let (data, _) = try? await URLSession.shared.data(for: urlRequest)
        else {
            return nil
        }

        guard let result = try? JSONDecoder().decode(Photo.self, from: data) else {
            return nil
        }

        return result
    }
    
    public func requestDetailPhoto(id: String) async -> DetailPhoto? {
        guard
            let urlRequest = PhotoAppAPI.detail(id: id).urlRequest,
            let (data, _) = try? await URLSession.shared.data(for: urlRequest)
        else {
            return nil
        }

        guard let result = try? JSONDecoder().decode(DetailPhoto.self, from: data) else {
            return nil
        }

        return result
    }
    
}
