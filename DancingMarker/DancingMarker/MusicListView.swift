//
//  MusicListView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI

struct MusicListView: View {
    @Environment(NavigationManager.self) var navigationManager
    //MARK: - 임의로 음원 있다고 가정, 추후 실제 음원 및 모델 사용 해야함
    @State private var musicList: [String] = []

    var body: some View {
        VStack {
            if musicList.isEmpty {
                VStack {
                    Text("추가된 음악이 없어요.")
                    Text("오른쪽 상단의 버튼을 눌러")
                    Text("음악을 추가해주세요.")
                }
                .font(.body)
            } else {
                List(musicList, id: \.self) { music in
                    HStack(spacing: 10){
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.gray)
                            .frame(width: 66, height: 66)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(music)
                                .font(.title3)
                                .bold()
                            Text("아티스트")
                                .font(.body)
                        }
                        
                    }
                }
                .listStyle(.inset)
            }
        }
        .navigationTitle("내 음악")
        .toolbar {
            ToolbarItem (placement: .topBarTrailing) {
                Button("추가하기") {
                    //navigationManager.push(to: .musicadd)
                    loadMusicList()
                }
            }
        }
    }
    
    private func loadMusicList() {
        // 실제 음원 데이터를 로드하는 로직을 여기에 추가합니다.
        // 예시로 임시 데이터를 추가합니다.
        musicList = ["음원 제목 1", "음원 제목 2"]
    }
}

#Preview {
    MusicListView()
        .environment(NavigationManager())
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)

}
