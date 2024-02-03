//
//  PhotoListView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import SwiftUI

struct PhotoListView: View {
    
    @ObservedObject var viewModel: PhotoListViewModel = .init()
    
    @State private var columns: [GridItem] = .init(
        repeating: .init(.flexible(), spacing: 13),
        count: 2
    )
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            VStack {
                                ForEach(viewModel.viewState.leftGrid, id: \.image) { data in
                                    Image(uiImage: data.image)
                                        .frame(width: geometryProxy.size.width / 2, height: (geometryProxy.size.width / 2) * data.ratio)
                                        .clipped()
                                }
                                Spacer()
                            }
                            
                            VStack {
                                ForEach(viewModel.viewState.rightGrid, id: \.image) { data in
                                    Image(uiImage: data.image)
                                        .frame(width: geometryProxy.size.width / 2, height: (geometryProxy.size.width / 2) * data.ratio)
                                        .clipped()
                                }
                                Spacer()
                            }
                            
                        }
                        if viewModel.viewState.appearProgress {
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                .simultaneousGesture(
                    DragGesture().onChanged({
                        viewModel.calculateScrollViewPosition(by: $0.translation.height)
                    }))
                
            }
            .onAppear {
                viewModel.loadPhotos()
            }
        }
    }
}

#Preview {
    PhotoListView()
}
