//
//  RandomPhotoViewModel.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import PhotoAppAPI
import PhotoAppCoreData

import Combine
import SwiftUI

final class RandomPhotoViewModel: ObservableObject {
    struct PhotoCard {
        let id: String
        let url: URL?
        var offsetWidth: CGFloat = .zero
    }
    
    struct ViewState {
        var photoStack: [PhotoCard] = []
    }
    
    @Published var viewState: ViewState = .init()
    
    private let networkService = PhotoNetworkService()
    private let metaDataService = BookmarkMetaDataService()
    
    let appearDetailPhotoView: PassthroughSubject<String, Never>
    
    init(appearDetailPhotoView: PassthroughSubject<String, Never>) {
        self.appearDetailPhotoView = appearDetailPhotoView
        
        loadCard(count: 2)
    }
    
}

extension RandomPhotoViewModel {
    
    func changeDragGesture(by translation: CGSize) {
        withAnimation {
            if var currentCard = viewState.photoStack.popLast() {
                currentCard.offsetWidth = translation.width
                viewState.photoStack.append(currentCard)
                
            }
        }
    }
    
    func endDragGesture(by translation: CGSize) {
        if var currentCard = viewState.photoStack.popLast() {
            if abs(translation.width) < 100 {
                withAnimation {
                    currentCard.offsetWidth = .zero
                    viewState.photoStack.append(currentCard)
                }
            } else {
                if translation.width > 0 {
                    try? metaDataService.save(by: .init(
                        id: .init(),
                        createdAt: .init(),
                        photoID: currentCard.id
                    ))
                }
                loadCard(count: 1)
            }
        }
    }
    
}

extension RandomPhotoViewModel {
    
    func tapInformationButton(by photoID: String) {
        appearDetailPhotoView.send(photoID)
    }
    
}

extension RandomPhotoViewModel {
    
    func loadCard(count: Int) {
        Task {
            for _ in 0..<count {
                if let randomPhoto = await networkService.requestRandomPhoto() {
                    await MainActor.run {
                        viewState.photoStack.insert(
                            PhotoCard(
                                id: randomPhoto.id,
                                url: URL(string: randomPhoto.url)),
                            at: 0)
                    }
                }
            }
        }
    }
    
}
