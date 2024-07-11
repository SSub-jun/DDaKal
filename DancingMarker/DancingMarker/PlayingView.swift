//
//  PlayingView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI

struct PlayingView: View {
    @Environment(NavigationManager.self) var navigationManager
    var music: Music
    
    /// 슬라이드용 임시 음원 정보
    @State private var progress: Double = 0.5 // 예시로 초기값 설정
    @State private var formattedProgress = "0:00"
    @State private var formattedDuration = "0:00"
    @State private var duration: TimeInterval = 100.0 // 예시로 재생 시간 설정
    @State private var currentTime: TimeInterval = 50.0 // 예시로 현재 시간 설정
        
    var body: some View {
        VStack {
            /// 음원 정보
            HStack(spacing: 10) {
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
            }
            .padding(.vertical, 12)
            
            HStack {
                Text("마커리스트")
                    .font(.headline)
                Spacer()
                
                Image(systemName: "questionmark.circle")
                    .foregroundStyle(.markerPurple)
            }
            .padding(.vertical, 12)
            
            Button(action: {
                        // 버튼 클릭 시 실행할 액션 추가
                    }) {
                        Text("추가")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 360, height: 60)
                            .background(.buttonDarkGray)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 8)
             
            Button(action: {
                        // 버튼 클릭 시 실행할 액션 추가
                    }) {
                        Text("추가")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 360, height: 60)
                            .background(.primaryYellow)
                            // 마커가 있을 경우 텍스트는 검은색으로
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 8)
            
            Button(action: {
                        // 버튼 클릭 시 실행할 액션 추가
                    }) {
                        Text("추가")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 360, height: 60)
                            .background(.buttonDarkGray)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 67)
            
            /// 배속 버튼
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 360, height: 50)
                .foregroundStyle(.buttonDarkGray)
                .overlay(
                    HStack(spacing: 10) {
                        Button(action: {
                            // Minus button action
                        }) {
                            Image(systemName: "minus")
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        
                        Button(action: {
                            // Close button action
                        }) {
                            Text("x1")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Button(action: {
                            // Plus button action
                        }) {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                    }
                        .padding(.horizontal, 20)
                )
                .padding(.bottom, 30)
            
            /// 슬라이더
            VStack() {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.inactiveGray)
                        
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width * CGFloat(self.progress), height: geometry.size.height)
                    }
                    .cornerRadius(12)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let newProgress = min(max(0, Double(value.location.x / geometry.size.width)), 1.0)
                            self.progress = newProgress
                            let newTime = newProgress * self.duration
                            self.currentTime = newTime
                            self.formattedProgress = self.formattedTime(newTime)
                        }))
                }
                .frame(height: 5) // Slider의 높이 설정
                
                
                HStack {
                    Text("\(self.formattedProgress)")
                    Spacer()
                    Text("\(self.formattedDuration)")
                }
            }
            .padding(.bottom, 40)
            
            HStack {
                Circle()
                    .foregroundStyle(.buttonDarkGray)
                    .frame(width: 60)
                    .overlay(
                Button(action: {
                            // 버튼 클릭 시 실행할 액션 추가
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
                            // 버튼 클릭 시 실행할 액션 추가
                        }) {
                            Image(systemName: "play.fill")
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
                            // 버튼 클릭 시 실행할 액션 추가
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }
    
    private func formattedTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: time)!
    }
}

#Preview {
    PlayingView(music: Music(title: "노래", artist: "아티스트", path: "", markers: [], albumArt: nil))
        .environment(NavigationManager())
        .preferredColorScheme(.dark)
}
