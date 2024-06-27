//
//  NowPlayingView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI

struct NowPlayingView: View {
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        Text("여기는 NowPlayingView")
    }
}

#Preview {
    NowPlayingView()
        .environment(NavigationManager())    
}
