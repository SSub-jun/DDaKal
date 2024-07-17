//
//  WCManager.swift
//  DancingMarker
//
//  Created by 변준섭 on 7/15/24.
//

import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    
    private let session: WCSession = WCSession.default
    var isReachable = false
    
    static var shared = WatchConnectivityManager()

    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        #if os(iOS)
        print("ACTIVATED ON IOS")
        #elseif os(watchOS)
        print("ACTIVATED ON WATCHOS")
        #endif
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
    
    #if os(iOS)
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session did become inactive: \(session.activationState.rawValue)")
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
        print("Session watch state did change: \(session.activationState.rawValue)")
    }
    #endif
    
    // MARK: MESSAGE RECEIVER

    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void
    ) {
        #if os(iOS)
        if let action = message["action"] as? String,
           action == "PlayToggle" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .plusCount,
                    object: nil
                )
                replyHandler(["success": true])
                print("성공!")
            }
        } else {
            replyHandler(["success": false])
        }
        
        if let action = message["action"] as? String,
           action == "Forward" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .forward,
                    object: nil
                )
                replyHandler(["success": true])
            }
        } else {
            replyHandler(["success": false])
        }
        
        
        if let action = message["action"] as? String,
           action == "Backward" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .backward,
                    object: nil
                )
                replyHandler(["success": true])
            }
        } else {
            replyHandler(["success": false])
        }
        
        if let action = message["action"] as? String,
           action == "SendIncreasePlayback" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .increaseSpeed,
                    object: nil
                )
                replyHandler(["success": true])
            }
        } else {
            replyHandler(["success": false])
        }
        
        if let action = message["action"] as? String,
           action == "SendDecreasePlayback" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .decreaseSpeed,
                    object: nil
                )
                replyHandler(["success": true])
            }
        } else {
            replyHandler(["success": false])
        }
        
        if let action = message["action"] as? String,
           action == "SendOriginalPlayback" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .originalSpeed,
                    object: nil
                )
                replyHandler(["success": true])
            }
        } else {
            replyHandler(["success": false])
        }
        
        if let action = message["action"] as? String,
           action == "MarkerPlay" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .markerPlay,
                    object: message["index"]
                )
                replyHandler(["success": true])
            }
        } else {
            replyHandler(["success": false])
        }
        
        if let action = message["action"] as? String,
           action == "MarkerSave" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .markerSave,
                    object: message["index"]
                )
                replyHandler(["success": true])
            }
        } else {
            replyHandler(["success": false])
        }
        
        
        #elseif os(watchOS)
        
        if let action = message["action"] as? String,
           action == "SendMarkers" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .sendMarkers,
                    object: message["markers"]
                )
                replyHandler(["success": true])
                print("성공!")
            }
        } else {
            replyHandler(["success": false])
        }
        
        if let action = message["action"] as? String,
           action == "SendSpeed" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .sendSpeed,
                    object: message["speed"]
                )
                replyHandler(["success": true])
                print("성공!")
            }
        } else {
            replyHandler(["success": false])
        }

        #endif
    }
    
    
    
    #if os (iOS)
    // MARK: iOS MESSAGE SENDERS
    func sendMarkersToWatch(_ markers: [TimeInterval]) {
        let message = [
            "action": "SendMarkers",
            "markers": markers
        ] as [String : Any]

        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    
    func sendSpeedToWatch(_ speed: Float){
        let message = [
            "action": "SendSpeed",
            "speed": speed
        ] as [String : Any]
        
        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    #endif
    
    
    
    
    // MARK: WATCH MESSAGE RECIEVERS

    
//    func session(
//        _ session: WCSession,
//        didReceiveMessage message: [String : Any],
//        replyHandler: @escaping ([String : Any]) -> Void
//    ) {
//
//    }
    
    
    // MARK: WATCH MESSAGE SENDERS
    #if os(watchOS)

    func sendPlayerLinkToIOS(_ link: String) {
        let message = [
            "action": "newPlayerLinkChosen",
            "link": link
        ]

        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    
    func sendPlayToggleToIOS() {
        let message = [
            "action": "PlayToggle"
        ]

        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    
    func sendForwardToIOS() {
        let message = [
            "action": "Forward"
        ]

        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    
    func sendBackwardToIOS() {
        let message = [
            "action": "Backward"
        ]

        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    func decreasePlaybackRate() {
//        connectivityManager.sendBackwardToIOS()
    }
    func increasePlaybackRate() {
//        connectivityManager.sendBackwardToIOS()
    }
    func originalPlaybckRate() {
//        connectivityManager.sendBackwardToIOS()
    }
    func sendIncreasePlaybackToIOS() {
        let message = [
            "action": "SendIncreasePlayback"
        ]

        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    
    func sendDecreasePlaybackToIOS() {
        let message = [
            "action": "SendDecreasePlayback"
        ]

        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    
    func sendOriginalPlaybackToIOS() {
        let message = [
            "action": "SendOriginalPlayback"
        ]

        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    #endif

    
    func sendMarkerPlayToIOS(_ index: Int) {
        let message = [
            "action": "MarkerPlay",
            "index": index
        ] as [String : Any]

        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    
    func sendMarkerSaveToIOS(_ index: Int) {
        let message = [
            "action": "MarkerSave",
            "index": index
        ] as [String : Any]

        session.sendMessage(message) { replyHandler in
            print(replyHandler)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
}

extension Notification.Name {
    
    static let newLinkChosen = Notification.Name("NewLinkChosen")
    static let plusCount = Notification.Name("PlusCount")
    static let forward = Notification.Name("Forward")
    static let backward = Notification.Name("Backward")
    static let markerPlay = Notification.Name("MarkerPlay")
    static let markerSave = Notification.Name("MarkerSave")
    static let increaseSpeed = Notification.Name("SendIncreasePlayback")
    static let decreaseSpeed = Notification.Name("SendDecreasePlayback")
    static let originalSpeed = Notification.Name("SendOriginalSpeed")

    static let sendMarkers = Notification.Name("SendMarkers")
    static let sendSpeed = Notification.Name("SendSpeed")
}
