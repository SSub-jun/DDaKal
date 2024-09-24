//
//  MusicEditView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI

struct MusicEditView: View {
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        VStack{
            Text("여기는 MusicEditView.")

            Button("Go to MusicListView") {
                navigationManager.push(to: .musicList)
            }.buttonBorderShape(.roundedRectangle)
        }
    }
}

#Preview {
    MusicEditView()
        .environment(NavigationManager())
}
