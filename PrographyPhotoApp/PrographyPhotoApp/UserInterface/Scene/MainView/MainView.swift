//
//  MainView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import SwiftUI
import PhotoAppAPI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            Image("prographyLogo")
                .padding()
            
            Rectangle()
                .fill(.black)
                .frame(width: UIScreen.main.bounds.width, height: 0.5)
            
            TabView(selection: $viewModel.viewState.selection) {
                PhotoListView()
                    .tag(viewModel.viewState.photoListTag)
                RandomPhotoView()
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
    }
}
