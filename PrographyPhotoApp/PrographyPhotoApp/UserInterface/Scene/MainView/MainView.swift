//
//  MainView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import SwiftUI
import PhotoAppAPI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabView(selection: $viewModel.viewState.selection) {
                    PhotoListView(viewModel: viewModel.photoListViewModel)
                        .tag(viewModel.viewState.photoListTag)
                    RandomPhotoView(viewModel: viewModel.randomPhotoViewModel)
                        .tag(viewModel.viewState.randomPhotoTag)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                HStack {
                    Spacer()
                    
                    Image("house")
                        .renderingMode(.template)
                        .foregroundStyle(viewModel.viewState.selection == .photoList ? .white : .gray)
                        .onTapGesture { viewModel.tapTabItem(by: .photoList) }
                    
                    Spacer()
                    
                    Image("cards")
                        .renderingMode(.template)
                        .foregroundStyle(viewModel.viewState.selection == .randomPhoto ? .white : .gray)
                        .onTapGesture { viewModel.tapTabItem(by: .randomPhoto) }
                    
                    Spacer()
                }
                .padding(.top, 20)
                .background(.black)
            }
            if let photoID = viewModel.viewState.appearDetailView {
                PhotoDetailView(
                    viewModel: .init(dependency: .init(
                        networkService: viewModel.dependency.networkSerview,
                        bookmarkService: viewModel.dependency.bookmarkService,
                        photoID: photoID
                    )),
                    tapPopButton: {
                        viewModel.viewState.appearDetailView = nil
                })
            }
        }
    }
}
