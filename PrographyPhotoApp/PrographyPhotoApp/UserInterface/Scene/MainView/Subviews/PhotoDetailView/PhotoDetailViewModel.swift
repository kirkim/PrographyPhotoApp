//
//  PhotoDetailViewModel.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/4/24.
//

import PhotoAppAPI

import UIKit.UIImage

final class PhotoDetailViewModel: ObservableObject {
    
    struct ViewState {
        let title: String
        let userName: String
        let description: String
        let tags: String
        let image: UIImage?
        var isBookmark: Bool = false
    }
    
    @Published var viewState: ViewState? = nil
    
    private let networkService = PhotoNetworkService()
    
    init(photoID: String) {
        Task {
            if let detailPhoto = await networkService.requestDetailPhoto(id: photoID),
               let imageData = await networkService.loadImage(urlString: detailPhoto.url)
            {
                
                await updateViewState(by: .init(
                    title: detailPhoto.tags.first ?? "",
                    userName: detailPhoto.user,
                    description: detailPhoto.description ?? "",
                    tags: detailPhoto.tags.prefix(4).reduce("") { $0 + "#\($1) "},
                    image: UIImage(data: imageData)
                ))
            }
        }
    }
    
}

extension PhotoDetailViewModel {
    
    func tapBookmarkButton() {
        
    }
    
}

extension PhotoDetailViewModel {
    
    @MainActor
    func updateViewState(by viewState: ViewState) {
        self.viewState = viewState
    }
    
}
