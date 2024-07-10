//
//  Music.swift
//  DancingMarker
//
//  Created by Woowon Kang on 7/4/24.
//

import Foundation
import SwiftData

@Model
class Music : Equatable {
    static func == (lhs: Music, rhs: Music) -> Bool {
            return lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    var title: String
    var artist: String
    var path: String
    var markers: [TimeInterval]
    var albumArt: Data?
    
    init(title: String, artist: String, path: String, markers: [TimeInterval], albumArt: Data?) {
        self.title = title
        self.artist = artist
        self.path = path
        self.markers = markers
        self.albumArt = albumArt
    }
}
