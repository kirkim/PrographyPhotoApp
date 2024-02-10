//
//  SkeletonView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/10/24.
//

import SwiftUI

struct SkeletonView: View {
    
    var shouldShow: Bool
    
    @State var opacity: Double = 0.4
    
    var body: some View {
        if shouldShow {
            ZStack {
                Color.white

                RoundedRectangle(cornerRadius: 8)
                    .fill(.black.opacity(0.8))
                    .opacity(self.opacity)
            }
            .onAppear(perform: {
                withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                    opacity = opacity == 0.2 ? 0.8 : 0.2
                }
            })
        }
    }
    
}

extension View {
    func setSkeletonView(shouldShow: Bool) -> some View {
        self.overlay(SkeletonView(shouldShow: shouldShow))
    }
}
