//
//  NavigationBar.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/4/24.
//

import SwiftUI

struct NavigationBar: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("prographyLogo")
                .padding()
            
            Rectangle()
                .fill(.black)
                .frame(width: UIScreen.main.bounds.width, height: 0.5)
        }
    }
}

#Preview {
    NavigationBar()
}
