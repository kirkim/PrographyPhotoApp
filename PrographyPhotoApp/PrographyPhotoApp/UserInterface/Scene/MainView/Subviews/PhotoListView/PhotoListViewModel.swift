//
//  PhotoListViewModel.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import UIKit.UIImage
import PhotoAppAPI

final class PhotoListViewModel: ObservableObject {
    struct CellInfo {
        let image: UIImage
        let ratio: CGFloat
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
    
    private let networkService: PhotoNetworkService = .init()
    @Published var viewState: ViewState = .init()
    private var gridInfo: GridInfo = .init()
    
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
                            addLeftGrid.append(.init(image: image, ratio: ratio))
                        } else {
                            weakSelf.gridInfo.rightHeight += ratio
                            addRightGrid.append(.init(image: image, ratio: ratio))
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
    
}
