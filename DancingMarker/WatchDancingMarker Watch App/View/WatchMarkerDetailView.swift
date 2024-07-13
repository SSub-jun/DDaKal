//
//  MarkerDetailView.swift
//  WatchDancingMarker Watch App
//
//  Created by 변준섭 on 6/25/24.
//

import SwiftUI

struct WatchMarkerDetailView: View {
    
    var body: some View {
        VStack{
            Text("5:13")
            Button(action:{
                
            }, label:{
                Text("수정하기")
            })
            Button(action:{
                
            }, label:{
                Text("삭제하기")
                    .foregroundStyle(.red)
            })
        }
        
    }
}

#Preview {
    WatchMarkerDetailView()
}
