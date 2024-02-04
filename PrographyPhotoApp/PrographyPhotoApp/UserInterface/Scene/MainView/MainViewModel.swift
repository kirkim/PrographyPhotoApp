//
//  MainViewModel.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import Combine
import SwiftUI

final class MainViewModel: ObservableObject {
    enum TabItem {
        case photoList
        case randomPhoto
    }
    
    struct ViewState {
        let photoListTag: TabItem = .photoList
        let randomPhotoTag: TabItem = .randomPhoto
        var selection: TabItem = .photoList
        var appearDetailView: String? = nil
    }
    
    @Published var viewState: ViewState = .init()
    
    private let appearDetailPhotoView: PassthroughSubject<String, Never> = .init()
    private var cancellableSet: Set<AnyCancellable> = []
    
    let photoListViewModel: PhotoListViewModel
    
    init() {
        self.photoListViewModel = .init(appearDetailPhotoView: appearDetailPhotoView)
        
        bind()
    }
    
}

extension MainViewModel {
    
    private func bind() {
        appearDetailPhotoView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photoID in
                self?.viewState.appearDetailView = photoID
            }
            .store(in: &cancellableSet)
    }
    
}

@MainActor
extension MainViewModel {
    
    func tapTabItem(by item: TabItem) {
        viewState.selection = item
    }
    
}
