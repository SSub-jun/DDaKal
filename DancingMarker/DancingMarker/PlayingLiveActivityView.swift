//
//  PlayingLiveActivityView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI

struct PlayingLiveActivityView: View {
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        Text("PlayingActivityView")
    }
}

#Preview {
    PlayingLiveActivityView()
        .environment(NavigationManager())
}
