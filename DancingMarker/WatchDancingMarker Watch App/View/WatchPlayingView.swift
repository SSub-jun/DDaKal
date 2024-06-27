//
//  PlayingView.swift
//  WatchDancingMarker Watch App
//
//  Created by 변준섭 on 6/25/24.
//

import SwiftUI

struct WatchPlayingView: View {
    @Environment(WatchNavigationManager.self) var navigationManager
    @State var showMarkerListOverlay : Bool = false
    
    var body: some View {
        ZStack{
            VStack {
                HStack{
                    Spacer()
                    Button(action: {
                        showMarkerListOverlay.toggle()
                    }, label:{
                        Image(systemName: "list.bullet")
                    }).buttonBorderShape(.circle)
                        .frame(width:50)

                }
                Spacer()
                
                TabView{
                    WatchPlayingMarkerView()
                    WatchPlayingSpeedView()
                }
                
                Spacer()
                HStack{
                    Button(action:{
                        
                    }, label:{
                        Image(systemName: "arrow.circlepath")
                    })
                    Button(action:{
                        
                    }, label:{
                        Image(systemName: "play.fill")
                    })
                    Button(action:{
                        
                    }, label:{
                        Image(systemName: "arrow.circlepath")

                    })
                }
            }
            if showMarkerListOverlay{
                WatchMarkerListView(showMarkerListOverlay: $showMarkerListOverlay)
            }
        }
        
    }
}

#Preview {
    WatchPlayingView()
        .environment(WatchNavigationManager())
}
