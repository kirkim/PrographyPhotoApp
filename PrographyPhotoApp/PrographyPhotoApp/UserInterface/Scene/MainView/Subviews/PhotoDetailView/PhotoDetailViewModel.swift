//
//  PhotoDetailViewModel.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/4/24.
//

import Foundation

final class PhotoDetailViewModel: ObservableObject {
    
    struct ViewState {
        let title: String
        let userName: String
        let description: String
        let tags: String
        let imageURL: URL?
        var isBookmark: Bool = false
    }
    
}

extension PhotoListViewModel {
    
    func tapBookmarkButton() {
        
    }
    
    func popButton() {
        
    }
    
}
