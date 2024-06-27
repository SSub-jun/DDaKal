//
//  PlayingView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI

struct PlayingView: View {
    @Environment(NavigationManager.self) var navigationManager
        
    var body: some View {
        Text("PlayingVIew")
    }
}

#Preview {
    PlayingView()
        .environment(NavigationManager())
}
