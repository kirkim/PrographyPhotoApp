//
//  PhotoDetailViewModel.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/4/24.
//

import PhotoAppAPI
import PhotoAppCoreData

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
    
    struct Dependency {
        let networkService: PhotoNetworkService
        let bookmarkService: BookmarkMetaDataService
        let photoID: String
    }
    
    @Published var viewState: ViewState? = nil
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        loadViewStateData()
    }
    
}

extension PhotoDetailViewModel {
    
    private func loadViewStateData() {
        Task { [weak self] in
            if
                let weakSelf = self,
                let detailPhoto = await weakSelf.dependency.networkService.requestDetailPhoto(id: weakSelf.dependency.photoID),
                let imageData = await weakSelf.dependency.networkService.loadImage(urlString: detailPhoto.url)
            {
                let existBookmarkData = weakSelf.existBookmarkData()
                await weakSelf.updateViewState(by: .init(
                    title: detailPhoto.tags.first ?? "",
                    userName: detailPhoto.user,
                    description: detailPhoto.description ?? "",
                    tags: detailPhoto.tags.prefix(4).reduce("") { $0 + "#\($1) "},
                    image: UIImage(data: imageData),
                    isBookmark: existBookmarkData
                ))
            }
        }
    }
    
    private func existBookmarkData() -> Bool {
        let data = try? dependency.bookmarkService.find(by: dependency.photoID)
        return data != nil
    }
    
}

extension PhotoDetailViewModel {
    
    @MainActor
    func tapBookmarkButton() {
        guard let viewState = viewState else {
            return
        }
        do {
            if viewState.isBookmark {
                let removableItem = try dependency.bookmarkService.find(by: dependency.photoID)
                try dependency.bookmarkService.remove(by: removableItem.id)
            } else {
                try dependency.bookmarkService.save(by: .init(photoID: dependency.photoID))
            }
            updateViewState(by: existBookmarkData())
        } catch {
            debugPrint(error)
        }
    }
    
}

@MainActor
extension PhotoDetailViewModel {
    
    func updateViewState(by viewState: ViewState) {
        self.viewState = viewState
    }
    
    func updateViewState(by isBookmark: Bool) {
        self.viewState?.isBookmark = isBookmark
    }
    
}
