//
//  WatchDancingMarkerApp.swift
//  WatchDancingMarker Watch App
//
//  Created by 변준섭 on 6/24/24.
//

import SwiftUI
import SwiftData

@main
struct WatchDancingMarker_Watch_AppApp: App {
    
    @StateObject var viewModel = WatchViewModel(connectivityManager: WatchConnectivityManager())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
