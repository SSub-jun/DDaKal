//
//  MarkerListOverlay.swift
//  WatchDancingMarker Watch App
//
//  Created by 변준섭 on 6/25/24.
//

import SwiftUI

struct WatchMarkerListView: View {
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView{
                    Button(action:{
                    }, label:{
                        Text("추가")
                    })
                    Button(action:{
                    }, label:{
                        Text("5:13")
                    })
                    Button(action:{
                    }, label:{
                        Text("추가")
                    })
                }
            }
        }
    }
}

#Preview {
    WatchMarkerListView()
}
