//
//  RandomPhotoCardView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import SwiftUI

struct RandomPhotoCardView: View {
    
    let imageURL: URL?
    let tapInformationIcon: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Color.black
                .cornerRadius(10)
                .overlay {
                    AsyncImage(url: imageURL, content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                    }, placeholder: {
                        ProgressView()
                    })
                }
                .padding()
                
            HStack {
                Spacer()
                
                Image("x")
                    .renderingMode(.template)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Circle()
                    .fill(.red)
                    .frame(width: 50)
                    .overlay {
                        Image("bookmark")
                            .renderingMode(.template)
                            .foregroundStyle(.white)
                    }
                
                Spacer()
                
                Button(action: {
                    tapInformationIcon()
                }, label: {
                    Image("information")
                        .renderingMode(.template)
                        .foregroundStyle(.gray)
                })
                
                Spacer()
            }
            .padding(.vertical, 20)
        }
        .background(.white)
        .cornerRadius(10)
    }
}
