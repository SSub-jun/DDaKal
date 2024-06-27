//
//  MusicListView.swift
//  WatchDancingMarker Watch App
//
//  Created by 변준섭 on 6/25/24.
//

import SwiftUI

struct WatchMusicListView: View {
    @Environment(WatchNavigationManager.self) var navigationManager

    var body: some View {
        ScrollView {
            Button("Music 1") {
                navigationManager.push(to: .playing)
            }.buttonBorderShape(.roundedRectangle)
            
            Button("Music 2") {
                navigationManager.push(to: .playing)
            }.buttonBorderShape(.roundedRectangle)
            
            Button("Music 3") {
                navigationManager.push(to: .playing)
            }.buttonBorderShape(.roundedRectangle)
            
            Button("Music 4") {
                navigationManager.push(to: .playing)
            }.buttonBorderShape(.roundedRectangle)
        }
    }
}

#Preview {
    WatchMusicListView()
        .environment(WatchNavigationManager())
}
