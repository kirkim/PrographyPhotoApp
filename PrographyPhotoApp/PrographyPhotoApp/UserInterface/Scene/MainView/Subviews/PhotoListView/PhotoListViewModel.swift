//
//  PhotoListViewModel.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import PhotoAppAPI

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
        var leftGrid: [CellInfo] = []
        var rightGrid: [CellInfo] = []
        var appearProgress: Bool = false
    }
    
    @Published var viewState: ViewState = .init()
    
    private let networkService: PhotoNetworkService = .init()
    private var gridInfo: GridInfo = .init()
    
    let appearDetailPhotoView: PassthroughSubject<String, Never>
    
    init(appearDetailPhotoView: PassthroughSubject<String, Never>) {
        self.appearDetailPhotoView = appearDetailPhotoView
    }
    
}

extension PhotoListViewModel {
    
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
    
    func tapItem(by info: CellInfo) {
        appearDetailPhotoView.send(info.photoID)
    }
    
}
