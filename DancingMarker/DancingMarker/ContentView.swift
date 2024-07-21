//
//  ContentView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/24/24.
// 

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var navigationManager = NavigationManager()
    @State private var showMusicList = false
    @State private var currentView: PathType? = nil
    @Query var musicList: [Music] = []
    @EnvironmentObject var playerModel: PlayerModel

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                //MARK: - 스플래시 화면 구현 필요
                switch currentView {
                case .musicList:
                    MusicListView()
                default: Text("Drop The Beat(로고)")
                        .font(.largeTitle)
                        .padding()
                }
            }
            .navigationDestination(for: PathType.self) { pathType in
                pathType.NavigatingView()
            }

        }
        .environment(navigationManager)
        .onAppear {
            resetShowMusicList()
            playerModel.sendMusicListToWatch(with: musicList)
        }
    }
    
    private func resetShowMusicList() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showMusicList = true
            currentView = .musicList
        }
    }
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}


