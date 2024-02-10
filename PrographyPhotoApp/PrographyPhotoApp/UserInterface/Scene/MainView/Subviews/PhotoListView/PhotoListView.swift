//
//  PhotoListView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import SwiftUI

struct PhotoListView: View {
    
    @ObservedObject var viewModel: PhotoListViewModel
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack(alignment: .leading, spacing: 20) {
                NavigationBar()
                
                Text("북마크")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.viewState.bookmarkGrid, id: \.id) { data in
                            Color.clear
                                .frame(width: geometryProxy.size.height / 5, height: geometryProxy.size.height / 5)
                                .overlay {
                                    LoadableImageView(
                                        title: data.title,
                                        asyncLoadImage: {
                                        await viewModel.loadImage(by: data.imageURL)
                                    })
                                }
                                .onTapGesture {
                                    viewModel.tapItem(by: data)
                                }
                        }
                    }
                }
                
                Text("최신 이미지")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ScrollView(.vertical, showsIndicators: false) {
                    HStack(spacing: 10) {
                        VStack {
                            ForEach(viewModel.viewState.leftGrid, id: \.id) { data in
                                Color.white
                                    .frame(width: geometryProxy.size.width / 2 - 15, height: (geometryProxy.size.width / 2) * data.ratio)
                                    .overlay {
                                        LoadableImageView(
                                            title: data.title,
                                            asyncLoadImage: {
                                            await viewModel.loadImage(by: data.imageURL)
                                        })
                                        .onTapGesture {
                                            viewModel.tapItem(by: data)
                                        }
                                    }
                            }
                            Spacer()
                        }
                        
                        VStack {
                            ForEach(viewModel.viewState.rightGrid, id: \.id) { data in
                                Color.white
                                    .frame(width: geometryProxy.size.width / 2 - 15, height: (geometryProxy.size.width / 2) * data.ratio)
                                    .overlay {
                                        LoadableImageView(
                                            title: data.title,
                                            asyncLoadImage: {
                                            await viewModel.loadImage(by: data.imageURL)
                                        })
                                        .onTapGesture {
                                            viewModel.tapItem(by: data)
                                        }
                                    }
                            }
                            Spacer()
                        }
                    }
                }
                .simultaneousGesture(
                    DragGesture().onChanged({
                        viewModel.calculateScrollViewPosition(by: $0.translation.height)
                    }))
            }
            .padding(.horizontal, 10)
        }
    }
}

extension PhotoListView {
    struct LoadableImageView: View {
        
        let title: String?
        let asyncLoadImage: () async -> UIImage?
        @State var image: UIImage?
        
        var body: some View {
            Color.white
                .overlay {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .overlay(alignment: .bottom) {
                                if let title = title {
                                    Text(title)
                                        .font(.caption)
                                        .lineLimit(2)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(.black.opacity(0.5))
                                }
                            }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .setSkeletonView(shouldShow: image == nil)
                .onAppear {
                    Task {
                        image = await asyncLoadImage()
                    }
                }
        }
    }
    
    
}
