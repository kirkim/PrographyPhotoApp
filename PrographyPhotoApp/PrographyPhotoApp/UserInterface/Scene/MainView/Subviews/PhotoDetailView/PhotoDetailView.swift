//
//  PhotoDetailView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/4/24.
//

import SwiftUI

struct PhotoDetailView: View {
    
    @ObservedObject var viewModel: PhotoDetailViewModel
    let tapPopButton: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: {
                    tapPopButton()
                }, label: {
                    Circle()
                        .fill(.white)
                        .frame(width: 40)
                        .overlay {
                            Image("x")
                                .renderingMode(.template)
                                .foregroundStyle(.black)
                        }
                })
                Text(viewModel.viewState?.userName ?? "UserName")
                    .font(.title2)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image("download")
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                })
                Button(action: {
                    
                }, label: {
                    Image("bookmark")
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                })
                .padding(.trailing, 10)
            }
            
            Spacer()
            
            Color.clear
                .frame(width: 300, height: 300)
                .cornerRadius(10)
                .overlay {
                    if let image = viewModel.viewState?.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 300, height: 300)
                    }
                }
            
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text(viewModel.viewState?.title ?? "Title")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(viewModel.viewState?.description ?? "")
                    .font(.caption)
                
                Text(viewModel.viewState?.tags ?? "")
                    .font(.caption)
            }
            .lineLimit(2)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(.black.opacity(0.9))
    }
}
