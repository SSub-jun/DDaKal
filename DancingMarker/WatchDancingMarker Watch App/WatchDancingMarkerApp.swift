//
//  WatchDancingMarkerApp.swift
//  WatchDancingMarker Watch App
//
//  Created by 변준섭 on 6/24/24.
//

import SwiftUI
import SwiftData
import Mixpanel

@main
struct WatchDancingMarker_Watch_AppApp: App {
    
    @StateObject var viewModel = WatchViewModel(connectivityManager: WatchConnectivityManager())
    
    init() {
        Mixpanel.initialize(token: "144330eb59a83d8fa14df18957c0e571")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
