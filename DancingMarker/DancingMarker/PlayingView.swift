//
//  PlayingView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI
import AVFoundation

struct PlayingView: View {
    @Environment(NavigationManager.self) var navigationManager
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var playerModel: PlayerModel

    var body: some View {
        VStack {
            /// 음원 정보
            HStack(spacing: 10) {
                if let music = playerModel.music {
                    
                    if let albumArtData = music.albumArt, let albumArt = UIImage(data: albumArtData) {
                        Image(uiImage: albumArt)
                            .resizable()
                            .frame(width: 66, height: 66)
                            .cornerRadius(13)
                    } else {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.gray)
                            .frame(width: 66, height: 66)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(music.title)
                            .font(.title3)
                            .bold()
                        Text(music.artist)
                            .font(.body)
                    }
                    Spacer()
                } else {
                    Text("선택된 음악이 없습니다.")
                }
            }
            .padding(.vertical, 12)
            
            /// 마커 리스트
            MarkerListView()
            
            /// 배속 버튼
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 360, height: 50)
                .foregroundStyle(.buttonDarkGray)
                .overlay(
                    HStack(spacing: 10) {
                        Button(action: {
                            playerModel.decreasePlaybackRate()
                        }) {
                            Image(systemName: "minus")
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        
                        Button(action: {
                            playerModel.playbackRate = 1.0
                            playerModel.updateAudioPlayer()
                        }) {
                            Text(String(format: "x%.1f", playerModel.playbackRate))
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Button(action: {
                            playerModel.increasePlaybackRate()
                        }) {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                    }
                        .padding(.horizontal, 20)
                )
                .padding(.bottom, 30)
                .padding(.top, 59)
            
            /// 슬라이더
            VStack() {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.inactiveGray)
                        
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width * CGFloat(playerModel.progress), height: geometry.size.height)
                    }
                    .cornerRadius(12)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            DispatchQueue.main.async {
                                let newProgress = min(max(0, Double(value.location.x / geometry.size.width)), 1.0)
                                playerModel.progress = newProgress
                                let newTime = newProgress * playerModel.duration
                                playerModel.currentTime = newTime
                                playerModel.formattedProgress = playerModel.formattedTime(newTime)
                                playerModel.updateAudioPlayer(with: newTime)
                            }
                        }))
                }
                .frame(height: 5)
                
                HStack {
                    Text("\(playerModel.formattedProgress)")
                    Spacer()
                    Text("\(playerModel.formattedDuration)")
                }
            }
            .padding(.bottom, 40)
            
            HStack {
                Circle()
                    .foregroundStyle(.buttonDarkGray)
                    .frame(width: 60)
                    .overlay(
                        Button(action: {
                            playerModel.backward5Sec()
                        }) {
                            Image(systemName: "gobackward.5")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36)
                                .foregroundStyle(.white)
                        }
                    )
                Spacer()
                
                Circle()
                    .foregroundStyle(.buttonDarkGray)
                    .frame(width: 80)
                    .overlay(
                        Button(action: {
                            playerModel.togglePlayback()
                        }) {
                            Image(systemName: playerModel.isPlaying ? "pause.fill" : "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .foregroundStyle(.white)
                        }
                            .frame(width: 30)
                    )
                Spacer()
                
                Circle()
                    .foregroundStyle(.buttonDarkGray)
                    .frame(width: 60)
                    .overlay(
                        Button(action: {
                            playerModel.forward5Sec()
                        }) {
                            Image(systemName: "goforward.5")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36)
                                .foregroundStyle(.white)
                        }
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear {
            if let music = playerModel.music {
                playerModel.initAudioPlayer(for: music)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }
    
    @ViewBuilder
    func MarkerListView() -> some View {
        VStack {
            HStack {
                Text("마커리스트")
                    .font(.headline)
                Spacer()
                
                Image(systemName: "questionmark.circle")
                    .foregroundStyle(.markerPurple)
            }
            .padding(.vertical, 12)
            
            VStack {
                if let music = playerModel.music {
                    ForEach(0..<3, id: \.self) { index in
                        let emptyTimeInterval: TimeInterval = 5999.0
                        if music.markers[index] != emptyTimeInterval {
                            playerModel.markerButton(for: music.markers[index])
                        } else {
                            playerModel.addMarkerButton(index: index)
                        }
                    }
                }
            }
            .padding(.bottom, 8)
            
        }
    }
    
}

//#Preview {
//    PlayingView(music: Music(title: "노래", artist: "아티스트", path: "", markers: [], albumArt: nil))
//        .environment(NavigationManager())
//        .preferredColorScheme(.dark)
//}
