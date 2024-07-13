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
    var music: Music
    
    /// 슬라이드용 임시 음원 정보
    @State private var progress: Double = 0.0 // 예시로 초기값 설정
    @State private var formattedProgress = "0:00"
    @State private var formattedDuration = "0:00"
    @State private var duration: TimeInterval = 0.0 // 예시로 재생 시간 설정
    @State private var currentTime: TimeInterval = 0.0 // 예시로 현재 시간 설정
    
    @State var audioPlayer: AVAudioPlayer?
    @State private var playbackRate: Float = 1.0
    @State private var isPlaying = false
    @State private var isDragging = false
    
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
            
            /// 마커 리스트
            MarkerListView()
            
            /// 배속 버튼
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 360, height: 50)
                .foregroundStyle(.buttonDarkGray)
                .overlay(
                    HStack(spacing: 10) {
                        Button(action: {
                            decreasePlaybackRate()
                        }) {
                            Image(systemName: "minus")
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        
                        Button(action: {
                            self.playbackRate = 1.0
                            self.updateAudioPlayer()
                        }) {
                            Text(String(format: "x%.1f", self.playbackRate))
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Button(action: {
                            increasePlaybackRate()
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
                            .frame(width: geometry.size.width * CGFloat(self.progress), height: geometry.size.height)
                    }
                    .cornerRadius(12)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let newProgress = min(max(0, Double(value.location.x / geometry.size.width)), 1.0)
                            self.progress = newProgress
                            let newTime = newProgress * self.duration
                            self.updateAudioPlayer(with: newTime)
                            self.currentTime = newTime
                            self.formattedProgress = self.formattedTime(newTime)
                        }))
                }
                .frame(height: 5)
                
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
                            backward5Sec()
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
                            togglePlayback()
                        }) {
                            Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
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
                            forward5Sec()
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
            initAudioPlayer()
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
                if let marker = music.markers[0] {
                    markerButton(for: marker, index: 0)
                } else {
                    addMarkerButton(index: 0)
                }
                
                if let marker = music.markers[1] {
                    markerButton(for: marker, index: 1)
                } else {
                    addMarkerButton(index: 1)
                }
                
                if let marker = music.markers[2] {
                    markerButton(for: marker, index: 2)
                } else {
                    addMarkerButton(index: 2)
                }
            }
            .padding(.bottom, 8)
            
        }
    }
    
    private func addMarkerButton(index: Int) -> some View {
        Button(action: {
            addMarker(at: index)
        }) {
            Text("추가")
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 360, height: 60)
                .background(Color.buttonDarkGray)
                .cornerRadius(12)
        }
    }
    
    private func addMarker(at index: Int) {
        guard let audioPlayer = audioPlayer else { return }
        
        let newMarker = audioPlayer.currentTime
        if music.markers.count > index {
            music.markers[index] = newMarker // 기존 마커 업데이트
        } else {
            music.markers.append(newMarker) // 새로운 마커 추가
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    @ViewBuilder
    private func markerButton(for marker: TimeInterval, index: Int) -> some View {
        Button(action: {
            moveToMarker(marker)
        }) {
            Text(formattedTime(marker))
                .font(.title3)
                .foregroundColor(.black)
                .frame(width: 360, height: 60)
                .background(Color.primaryYellow)
                .cornerRadius(12)
        }
        .contextMenu{
            Button(action: {
                // 수정 기능
            }) {
                Text("수정하기")
                Image(systemName: "pencil")
            }
            Button(role: .destructive, action: {
                deleteMarker(at: index)
            }) {
                Text("삭제하기")
                Image(systemName: "trash")
            }
        }
    }
    
    private func deleteMarker(at index: Int) {
        guard index < music.markers.count else { return }
        
        music.markers[index] = nil
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deleting marker: \(error.localizedDescription)")
        }
    }
    
    private func moveToMarker(_ marker: TimeInterval) {
        self.audioPlayer?.currentTime = marker
        self.progress = CGFloat(marker / self.duration)
        self.formattedProgress = self.formattedTime(marker)
        audioPlayer?.play()
        isPlaying = true
    }
    
    private func formattedTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: time)!
    }
    
    /// 배속 조절 기능
    private func decreasePlaybackRate() {
        if self.playbackRate > 0.5 {
            self.playbackRate -= 0.1
            self.updateAudioPlayer()
        }
    }
    
    private func increasePlaybackRate() {
        if self.playbackRate < 2.0 {
            self.playbackRate += 0.1
            self.updateAudioPlayer()
        }
    }
    
    private func updateAudioPlayer() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.rate = playbackRate
        
    }
    
    private func updateAudioPlayer(with time: TimeInterval) {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.currentTime = time
    }
    
    /// 음원 재생, 조작, 초기화
    private func initAudioPlayer() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        
        print("Attempting to load file at path: \(music.path)")
        
        // 파일 존재 여부 확인
        guard FileManager.default.fileExists(atPath: music.path.path) else {
            print("File not found at path: \(music.path)")
            return
        }
        
        do {
            // AVAudioSession 설정
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            
            // AVAudioPlayer 초기화
            self.audioPlayer = try AVAudioPlayer(contentsOf: music.path)
            guard let audioPlayer = self.audioPlayer else {
                print("Failed to initialize audio player")
                return
            }
            
            // 오디오 플레이어 준비 및 속성 설정
            audioPlayer.prepareToPlay()
            audioPlayer.enableRate = true
            
            // 포맷된 길이 설정
            formattedDuration = formatter.string(from: audioPlayer.duration) ?? "0:00"
            duration = audioPlayer.duration
            
            // 타이머 설정
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if !audioPlayer.isPlaying {
                    self.isPlaying = false
                }
                
                if !self.isDragging {
                    self.currentTime = audioPlayer.currentTime
                    self.progress = audioPlayer.duration > 0 ? Double(audioPlayer.currentTime / audioPlayer.duration) : 0
                    self.formattedProgress = self.formattedTime(audioPlayer.currentTime)
                }
            }
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
    
    private func togglePlayback() {
        if let audioPlayer = audioPlayer {
            if self.isPlaying {
                audioPlayer.pause()
            } else {
                audioPlayer.play()
            }
            self.isPlaying.toggle()
        }
    }
    
    /// 음원 5초 앞으로 뒤로 가기 기능
    private func seekToTime(to time: TimeInterval) {
        guard let player = audioPlayer else { return }
        player.currentTime = time
        progress = CGFloat(time / player.duration)
        formattedProgress = formattedTime(time)
    }
    
    private func backward5Sec() {
        guard let player = audioPlayer else { return }
        let newTime = max(player.currentTime - 5, 0)
        seekToTime(to: newTime)
        // 제어 센터 업데이트 코드 추가
    }
    
    private func forward5Sec() {
        guard let player = audioPlayer else { return }
        let newTime = min(player.currentTime + 5, player.duration)
        seekToTime(to: newTime)
        // 제어 센터 업데이트 코드 추가
    }
    
}

//#Preview {
//    PlayingView(music: Music(title: "노래", artist: "아티스트", path: "", markers: [], albumArt: nil))
//        .environment(NavigationManager())
//        .preferredColorScheme(.dark)
//}
