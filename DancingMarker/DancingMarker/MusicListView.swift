//
//  MusicListView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI

struct MusicListView: View {
    @Environment(NavigationManager.self) var navigationManager

    var body: some View {
        VStack{
            HStack(spacing: 10){
                RoundedRectangle(cornerRadius: 13)
                    .fill(Color.gray)
                    .frame(width: 66, height: 66)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("음원 제목")
                        .font(.title3)
                        .bold()
                    Text("아티스트")
                        .font(.body)
                }

            }
        }
        .navigationTitle("내 음악")
        .toolbar {
            ToolbarItem (placement: .topBarTrailing) {
                Button("추가하기") {
                    navigationManager.push(to: .musicadd)
                }
            }
        }
    }
}

#Preview {
    MusicListView()
        .environment(NavigationManager())
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)

}
