//
//  PhotoListViewModel.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import PhotoAppAPI
import PhotoAppCoreData

import Combine
import UIKit.UIImage

final class PhotoListViewModel: ObservableObject {
    struct CellInfo {
        let image: UIImage
        let ratio: CGFloat
        let photoID: String
    }
    
    struct GridInfo {
        var page: Int = 0
        var leftHeight: CGFloat = .zero
        var rightHeight: CGFloat = .zero
    }
    
    struct ViewState {
        var bookmarkGrid: [CellInfo] = []
        var leftGrid: [CellInfo] = []
        var rightGrid: [CellInfo] = []
    }
    
    @Published var viewState: ViewState = .init()
    
    private let networkService: PhotoNetworkService = .init()
    private let bookmarkService: BookmarkMetaDataService = .init()
    private var gridInfo: GridInfo = .init()
    
    let appearDetailPhotoView: PassthroughSubject<String, Never>
    
    init(appearDetailPhotoView: PassthroughSubject<String, Never>) {
        self.appearDetailPhotoView = appearDetailPhotoView
        
        loadBookmarkPhotos()
        loadPhotos()
    }
    
}

extension PhotoListViewModel {
    
    func loadBookmarkPhotos() {
        Task { [weak self] in
            guard 
                let weakSelf = self,
                let bookmarkInfos = try? weakSelf.bookmarkService.fetch()
            else { return }
            
            var bookmarkCellInfo: [CellInfo] = []
            for info in bookmarkInfos {
                if let urlString = await weakSelf.networkService.requestDetailPhoto(id: info.photoID)?.url,
                   let imageData = await weakSelf.networkService.loadImage(urlString: urlString),
                   let uiImage = UIImage(data: imageData)
                {
                    bookmarkCellInfo.append(.init(
                        image: uiImage,
                        ratio: .zero,
                        photoID: info.photoID
                    ))
                }
            }
            await weakSelf.updateBookmarkInfos(by: bookmarkCellInfo)
        }
    }
    
    func loadPhotos() {
        Task { [weak self] in
            guard let weakSelf = self else { return }
            if let datas = await weakSelf.networkService.requestPhotos(page: weakSelf.gridInfo.page) {
                var addLeftGrid: [CellInfo] = []
                var addRightGrid: [CellInfo] = []
                for data in datas {
                    let ratio = data.height / data.width
                    if let imageData = await weakSelf.networkService.loadImage(urlString: data.url),
                       let image = UIImage(data: imageData) {
                        if weakSelf.gridInfo.leftHeight <= weakSelf.gridInfo.rightHeight {
                            weakSelf.gridInfo.leftHeight += ratio
                            addLeftGrid.append(.init(image: image, ratio: ratio, photoID: data.id))
                        } else {
                            weakSelf.gridInfo.rightHeight += ratio
                            addRightGrid.append(.init(image: image, ratio: ratio, photoID: data.id))
                        }
                    }
                }
                weakSelf.gridInfo.page += 1
                var newViewState = weakSelf.viewState
                newViewState.leftGrid += addLeftGrid
                newViewState.rightGrid += addRightGrid
                await weakSelf.updateViewState(by: newViewState)
            }
        }
    }
    
    func calculateScrollViewPosition(by value: CGFloat) {
        if value < 0 {
            loadPhotos()
        }
    }
    
}

@MainActor
extension PhotoListViewModel {
    
    func updateViewState(by newViewState: ViewState) {
        viewState = newViewState
    }
    
    func updateBookmarkInfos(by bookmarkInfos: [CellInfo]) {
        viewState.bookmarkGrid = bookmarkInfos
    }
    
    func tapItem(by info: CellInfo) {
        appearDetailPhotoView.send(info.photoID)
    }
    
}
