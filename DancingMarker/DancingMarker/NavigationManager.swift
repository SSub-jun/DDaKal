//
//  NavigationManager.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI

enum PathType: Hashable {
    case musicList
    case musicadd
    case musicedit
    case playing(music: Music)
    case nowplaying
}

extension PathType {
    @ViewBuilder
    func NavigatingView() -> some View {
        switch self {
        case .musicList:
            MusicListView()
            
        case .musicadd:
            MusicAddView()
            
        case .musicedit:
            MusicEditView()
            
        case .playing(let music):
            PlayingView(music: music)
            
        case .nowplaying:
            NowPlayingView()
        }
    }
}

@Observable
class NavigationManager {
    var path: [PathType]
    init(
        path: [PathType] = []
    ){
        self.path = path
    }
}

extension NavigationManager {
    func push(to pathType: PathType) {
        path.append(pathType)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func pop(to pathType: PathType) {
        guard let lastIndex = path.lastIndex(of: pathType) else { return }
        path.removeLast(path.count - (lastIndex + 1))
    }
}

