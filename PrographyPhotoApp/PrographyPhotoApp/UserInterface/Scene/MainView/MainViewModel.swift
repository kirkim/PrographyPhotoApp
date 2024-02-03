//
//  MainViewModel.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

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
    }
    
    @Published var viewState: ViewState = .init()
    
}

@MainActor
extension MainViewModel {
    
    func tapTabItem(by item: TabItem) {
        viewState.selection = item
    }
    
}
