//
//  MusicListView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI

struct MusicListView: View {
    @Environment(NavigationManager.self) var navigationManager

    
    var body: some View {
        VStack{
            Spacer()
            Text("여기는 MusicListView.")
            Spacer()
            Button("Go to MusicAddView") {
                navigationManager.push(to: .musicadd)
            }.buttonBorderShape(.roundedRectangle)
            Spacer()
            Button("Go to PlayingView") {
                navigationManager.push(to: .playing)
            }.buttonBorderShape(.roundedRectangle)
            Spacer()
            Button("Go to NowPlayingView") {
                navigationManager.push(to: .nowplaying)
            }.buttonBorderShape(.roundedRectangle)
            Spacer()
        }
    }
}

#Preview {
    MusicListView()
        .environment(NavigationManager())

}
