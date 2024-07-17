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
}
