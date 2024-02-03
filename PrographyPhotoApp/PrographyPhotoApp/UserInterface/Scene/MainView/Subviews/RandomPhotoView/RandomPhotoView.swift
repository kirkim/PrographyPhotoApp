//
//  RandomPhotoView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import SwiftUI

struct RandomPhotoView: View {

    @StateObject var viewModel: RandomPhotoViewModel = .init()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(viewModel.viewState.photoStack, id: \.id) { photoCard in
                    RandomPhotoCardView(imageURL: photoCard.url)
                        .padding(50)
                        .shadow(radius: 5)
                        .offset(x: photoCard.offsetWidth, y: 0)
                        .rotationEffect(.degrees(Double(photoCard.offsetWidth / geometry.size.width) * 25), anchor: .bottom)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    viewModel.changeDragGesture(by: gesture.translation)
                                }
                                .onEnded { gesture in
                                    viewModel.endDragGesture(by: gesture.translation)
                                }
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
