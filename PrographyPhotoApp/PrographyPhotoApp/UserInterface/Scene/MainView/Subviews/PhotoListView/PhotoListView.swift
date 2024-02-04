//
//  PhotoListView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import SwiftUI

struct PhotoListView: View {
    
    @ObservedObject var viewModel: PhotoListViewModel
    
    @State private var columns: [GridItem] = .init(
        repeating: .init(.flexible(), spacing: 13),
        count: 2
    )
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack(alignment: .leading, spacing: 20) {
                NavigationBar()
                
                Text("북마크")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.viewState.bookmarkGrid, id: \.image) { data in
                            Image(uiImage: data.image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: geometryProxy.size.height / 5)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
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
                    VStack {
                        HStack(spacing: 10) {
                            VStack {
                                ForEach(viewModel.viewState.leftGrid, id: \.image) { data in
                                    Image(uiImage: data.image)
                                        .frame(width: geometryProxy.size.width / 2 - 15, height: (geometryProxy.size.width / 2) * data.ratio)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .onTapGesture {
                                            viewModel.tapItem(by: data)
                                        }
                                }
                                Spacer()
                            }
                            
                            VStack {
                                ForEach(viewModel.viewState.rightGrid, id: \.image) { data in
                                    Image(uiImage: data.image)
                                        .frame(width: geometryProxy.size.width / 2 - 15, height: (geometryProxy.size.width / 2) * data.ratio)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .onTapGesture {
                                            viewModel.tapItem(by: data)
                                        }
                                }
                                Spacer()
                            }
                            
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
