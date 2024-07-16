//
//  ViewModel.swift
//  DancingMarker
//
//  Created by 변준섭 on 7/16/24.
//

import SwiftUI
import NotificationCenter
import AVFoundation
import MediaPlayer

class PlayerModel: ObservableObject {
    
    var music: Music?
    @Environment(\.modelContext) private var modelContext
    var connectivityManager: WatchConnectivityManager

    @Published var progress: Double = 0.0 // 예시로 초기값 설정
    @Published var formattedProgress = "0:00"
    @Published var formattedDuration = "0:00"
    @Published var duration: TimeInterval = 0.0 // 예시로 재생 시간 설정
    @Published var currentTime: TimeInterval = 0.0 // 예시로 현재 시간 설정
    
    @Published var audioPlayer: AVAudioPlayer?
    @Published var playbackRate: Float = 1.0
    @Published var isPlaying = false
    @Published var isDragging = false
    
    @Published var countNum: Int = 0


    init(connectivityManager: WatchConnectivityManager) {
        self.connectivityManager = connectivityManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationPlaytoggleAction),
            name: .plusCount,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationForwardAction),
            name: .forward,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationBackwardAction),
            name: .backward,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationMarkerPlayAction),
            name: .markerPlay,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationMarkerSaveAction),
            name: .markerSave,
            object: nil
        )
    }
    
    @objc func notificationPlaytoggleAction(_ notification: Notification) {
        self.countNum = countNum + 1
        togglePlayback()
    }
    
    
    @objc func notificationForwardAction(_ notification: Notification) {
        self.countNum = countNum + 1
        forward5Sec()
    }
    
    @objc func notificationBackwardAction(_ notification: Notification) {
        self.countNum = countNum + 1
        backward5Sec()
    }
    
    @objc func notificationMarkerPlayAction(_ notification: Notification) {
        self.countNum = countNum + 1
        guard let music = music else { return }
        
        if let index = notification.object as? Int, index >= 0, index < music.markers.count {
            let marker = music.markers[index]
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.currentTime = marker
            self.progress = CGFloat(marker / self.duration)
            self.formattedProgress = self.formattedTime(marker)
            audioPlayer.play()
            self.isPlaying = true
        } else {
            print("Invalid marker index or index out of bounds")
        }
    }
    
    @objc func notificationMarkerSaveAction(_ notification: Notification) {
        self.countNum = countNum + 1
        guard let music = music else { return }
        if let index = notification.object as? Int, index >= 0, index < music.markers.count {
            guard let audioPlayer = audioPlayer else { return}
            music.markers[index] = audioPlayer.currentTime
            self.connectivityManager.sendMarkersToWatch(music.markers)
        } else {
            print("Invalid marker index or index out of bounds")
        }
    }
    
    func addMarkerButton(index: Int) -> some View {
        Button(action: {
            DispatchQueue.main.async{
                guard let music = self.music else { return }
                self.addMarker(at: index)
                self.connectivityManager.sendMarkersToWatch(music.markers)
            }
            
        }) {
            Text("추가")
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 360, height: 60)
                .background(Color.buttonDarkGray)
                .cornerRadius(12)
        }
    }
    
    func addMarker(at index: Int) {
        guard let audioPlayer = audioPlayer else { return }
        guard let music = music else { return }
        let newMarker = audioPlayer.currentTime
        
//        if music.markers.count > index {
//            music.markers[index] = newMarker
//        } else {
//            music.markers.append(newMarker)
//        }
        music.markers[index] = newMarker
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    @ViewBuilder
    func markerButton(for marker: TimeInterval) -> some View {
        Button(action: {
            self.moveToMarker(marker)
        }) {
            Text(formattedTime(marker))
                .font(.title3)
                .italic()
                .foregroundColor(.black)
                .frame(width: 360, height: 60)
                .background(Color.primaryYellow)
                .cornerRadius(12)
        }
    }
    
    private func moveToMarker(_ marker: TimeInterval) {
        self.audioPlayer?.currentTime = marker
        self.progress = CGFloat(marker / self.duration)
        self.formattedProgress = self.formattedTime(marker)
        audioPlayer?.play()
        isPlaying = true
    }
    
    func formattedTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: time)!
    }
    
    /// 배속 조절 기능
    func decreasePlaybackRate() {
        if self.playbackRate > 0.5 {
            self.playbackRate -= 0.1
            self.updateAudioPlayer()
        }
    }
    
    func increasePlaybackRate() {
        if self.playbackRate < 2.0 {
            self.playbackRate += 0.1
            self.updateAudioPlayer()
        }
    }
    
    func updateAudioPlayer() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.rate = playbackRate
        
    }
    
    func updateAudioPlayer(with time: TimeInterval) {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.currentTime = time
    }
    
    /// 음원 재생, 조작, 초기화
    func initAudioPlayer() {
        guard let music = music else { return }
        
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
    
    func togglePlayback() {
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
    func seekToTime(to time: TimeInterval) {
        guard let player = audioPlayer else { return }
        player.currentTime = time
        progress = CGFloat(time / player.duration)
        formattedProgress = formattedTime(time)
    }
    
    func backward5Sec() {
        guard let player = audioPlayer else { return }
        let newTime = max(player.currentTime - 5, 0)
        seekToTime(to: newTime)
        // 제어 센터 업데이트 코드 추가
    }
    
    func forward5Sec() {
        guard let player = audioPlayer else { return }
        let newTime = min(player.currentTime + 5, player.duration)
        seekToTime(to: newTime)
        // 제어 센터 업데이트 코드 추가
    }
}
