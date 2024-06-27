//
//  MarkerListOverlay.swift
//  WatchDancingMarker Watch App
//
//  Created by 변준섭 on 6/25/24.
//

import SwiftUI

struct WatchMarkerListView: View {
    @Environment(WatchNavigationManager.self) var navigationManager
    @Binding var showMarkerListOverlay: Bool
    
    var body: some View {
        ZStack{
            Color.black
            VStack{
                HStack{
                    Button(action: {
                        showMarkerListOverlay.toggle()
                    }, label:{
                        Image(systemName: "xmark")
                    }).buttonBorderShape(.circle)
                        .frame(width:50)
                    Spacer()
                }
                ScrollView{
                    Button(action:{
                        navigationManager.push(to: .markerDetail)
                    }, label:{
                        Text("추가")
                    })
                    Button(action:{
                        navigationManager.push(to: .markerDetail)
                    }, label:{
                        Text("5:13")
                    })
                    Button(action:{
                        navigationManager.push(to: .markerDetail)
                    }, label:{
                        Text("추가")
                    })
                }
            }
        }
        
    }
}
