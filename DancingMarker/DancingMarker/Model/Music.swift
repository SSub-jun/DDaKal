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
    
    let id: UUID
    var title: String
    var artist: String
    var path: URL
    var markers: [TimeInterval]
    var albumArt: Data?
    
    subscript(key: String) -> Any {
            switch key {
            case "title" :
                return title
                
            case "artist" :
                return artist
                    
            case "path" :
                return path
                
            case "markers" :
                return markers
                
            case "albumArt" :
                return albumArt ?? Data()
                
            default :
                return "invalid"
            }
        }
    
    init(title: String, artist: String, path: URL, markers: [TimeInterval], albumArt: Data?) {
        self.id = UUID()
        self.title = title
        self.artist = artist
        self.path = path
        self.markers = markers
        self.albumArt = albumArt
    }
}
