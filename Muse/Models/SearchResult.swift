//
//  SearchResult.swift
//  Muse
//
//  Created by Michel Maalouli on 10/22/22.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
