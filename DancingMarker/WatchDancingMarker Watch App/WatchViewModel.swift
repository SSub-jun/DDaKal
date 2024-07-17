//
//  ViewModel.swift
//  WatchDancingMarker Watch App
//
//  Created by 변준섭 on 7/16/24.
//
import SwiftUI

class WatchViewModel: ObservableObject {
    
    var music: Music?
    
    var connectivityManager: WatchConnectivityManager
    @Published var markers: [String] = ["99:59", "99:59", "99:59"]
    @Published var speed: Float = 1.0
    @Published var isPlaying = false
    
    @Published var progress: Double = 0.0 // 예시로 초기값 설정
    @Published var formattedProgress = "0:00"
    @Published var formattedDuration = "0:00"
    @Published var duration: TimeInterval = 0.0 // 예시로 재생 시간 설정
    @Published var currentTime: TimeInterval = 0.0 // 예시로 현재 시간 설정
    
    private var timer: Timer?
    
    init(connectivityManager: WatchConnectivityManager) {
        self.connectivityManager = connectivityManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateMarkers(_:)),
            name: .sendMarkers,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateSpeed(_:)),
            name: .sendSpeed,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateIsPlaying(_:)),
            name: .sendIsPlaying,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updatePlayingTimes(_:)),
            name: .sendPlayingTimes,
            object: nil
        )
    }
    convenience init() {
           self.init(connectivityManager: WatchConnectivityManager())
       }
    
    @objc func updateMarkers(_ notification: Notification) {
        if let markers = notification.object as? [TimeInterval] {
            // 수신한 markers 데이터를 처리하는 로직
            self.markers = markers.compactMap { self.formattedTime($0) }
        }
    }
    
    @objc func updateSpeed(_ notification: Notification) {
        if let speed = notification.object as? Float {
            // 수신한 markers 데이터를 처리하는 로직
            self.speed = speed
        }
    }
    
    @objc func updateIsPlaying(_ notification: Notification) {
        if let isPlaying = notification.object as? Bool {
            // 수신한 markers 데이터를 처리하는 로직
            self.isPlaying = isPlaying
            if isPlaying {
                startTimer()
            } else{
                stopTimer()
            }
        }
    }
    
    @objc func updatePlayingTimes(_ notification: Notification) {
        if let playingTimes = notification.object as? [TimeInterval] {
            // 수신한 markers 데이터를 처리하는 로직
            DispatchQueue.main.async{
                self.currentTime = playingTimes[0]
                self.duration = playingTimes[1]
                self.progress = self.currentTime / self.duration
                self.formattedProgress = self.formattedTime(self.currentTime)
            }
        }
    }
    
    func playToggle() {
        connectivityManager.sendPlayToggleToIOS()
    }
    
    func playForward() {
        connectivityManager.sendForwardToIOS()
    }
    func playBackward() {
        connectivityManager.sendBackwardToIOS()
    }
    func decreasePlaybackRate() {
        connectivityManager.sendDecreasePlaybackToIOS()
    }
    func increasePlaybackRate() {
        connectivityManager.sendIncreasePlaybackToIOS()
    }
    func originalPlaybckRate() {
        connectivityManager.sendOriginalPlaybackToIOS()
    }
    
    func formattedTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: time)!
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTime()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTime() {
        guard isPlaying else { return }
        currentTime += 1
        if currentTime >= duration {
            currentTime = duration
            stopTimer()
        }
        progress = currentTime / duration
        formattedProgress = formattedTime(currentTime)
    }
}
