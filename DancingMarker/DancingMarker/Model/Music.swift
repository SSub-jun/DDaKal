//
//  Music.swift
//  DancingMarker
//
//  Created by Woowon Kang on 7/4/24.
//

import Foundation
import SwiftData

@Model
class Player {
    var title: String
    var artist: String
    var path: String
    var markers: [TimeInterval]
    
    init(title: String, artist: String, path: String, markers: [TimeInterval]) {
        self.title = title
        self.artist = artist
        self.path = path
        self.markers = markers
    }
}
