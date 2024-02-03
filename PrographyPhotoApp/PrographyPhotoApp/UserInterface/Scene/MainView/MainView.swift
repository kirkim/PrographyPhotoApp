//
//  MainView.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import SwiftUI
import PhotoAppAPI

struct MainView: View {
    
    var body: some View {
        VStack {
            // MARK: 네비게이션 바
            TabView {
                PhotoListView()
                    .tabItem {
                        Image("house")
                    }
                RandomPhotoView()
                    .tabItem {
                        Image("cards")
                    }
            }
        }
    }
}

#Preview {
    MainView()
}
