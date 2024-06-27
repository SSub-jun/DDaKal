//
//  MusicAddView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI

struct MusicAddView: View {
    @Environment(NavigationManager.self) var navigationManager
    var body: some View {
        VStack{
            Text("여기는 MusicAddView.")
            Button("Go to EditView") {
                navigationManager.push(to: .musicedit)
            }.buttonBorderShape(.roundedRectangle)
        }
    }
}

#Preview {
    MusicAddView()
        .environment(NavigationManager())
}
