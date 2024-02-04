//
//  PrographyPhotoAppApp.swift
//  PrographyPhotoApp
//
//  Created by 김기림 on 2/3/24.
//

import SwiftUI
import PhotoAppAPI
import PhotoAppCoreData

@main
struct PrographyPhotoAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: .init(dependency: .init(
                networkSerview: .init(),
                bookmarkService: .init()
            )))
        }
    }
}
