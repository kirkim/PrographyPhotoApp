//
//  RandomPhotoView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import SwiftUI

struct RandomPhotoView: View {

    @StateObject var viewModel: RandomPhotoViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                NavigationBar()
                
                ForEach(viewModel.viewState.photoStack, id: \.id) { photoCard in
                    RandomPhotoCardView(
                        imageURL: photoCard.url,
                        tapInformationIcon: {
                            viewModel.tapInformationButton(by: photoCard.id)
                        })
                        .padding(EdgeInsets(top: 100, leading: 50, bottom: 100, trailing: 50))
                        .shadow(radius: 5)
                        .offset(x: photoCard.offsetWidth, y: -abs(photoCard.offsetWidth))
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
                        .zIndex(0)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
