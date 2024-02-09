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
    
    struct Dependency {
        let networkService: PhotoNetworkService
        let bookmarkService: BookmarkMetaDataService
        let appearDetailPhotoViewSubject: PassthroughSubject<String, Never>
    }
    
    @Published var viewState: ViewState = .init()
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var gridInfo: GridInfo = .init()
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        loadPhotos()
        bind()
    }
    
}

extension PhotoListViewModel {
    
    private func bind() {
        dependency.bookmarkService.dataSourceSubject
            .receive(on: DispatchQueue.main)
            .sink { bookmarkInfos in
                Task { [weak self] in
                    guard let weakSelf = self else { return }
                    
                    var bookmarkCellInfo: [CellInfo] = []
                    for info in bookmarkInfos {
                        if let urlString = await weakSelf.dependency.networkService.requestDetailPhoto(id: info.photoID)?.url,
                           let imageData = await weakSelf.dependency.networkService.loadImage(urlString: urlString),
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
            .store(in: &cancellableSet)
    }
    
    func loadPhotos() {
        Task { [weak self] in
            guard let weakSelf = self else { return }
            if let datas = await weakSelf.dependency.networkService.requestPhotos(page: weakSelf.gridInfo.page) {
                var addLeftGrid: [CellInfo] = []
                var addRightGrid: [CellInfo] = []
                for data in datas {
                    let ratio = data.height / data.width
                    if let imageData = await weakSelf.dependency.networkService.loadImage(urlString: data.url),
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
    
    private func updateViewState(by newViewState: ViewState) {
        viewState = newViewState
    }
    
    private func updateBookmarkInfos(by bookmarkInfos: [CellInfo]) {
        viewState.bookmarkGrid = bookmarkInfos
    }
    
    func tapItem(by info: CellInfo) {
        dependency.appearDetailPhotoViewSubject.send(info.photoID)
    }
    
}
