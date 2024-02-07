//
//  SearchViewModel.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 30.01.2024.
//

import Foundation

struct SearchViewModel{
    let podcast: Podcast
    init(podcast: Podcast) {
        self.podcast = podcast
    }
    var photoImageUrl: URL? {
        return URL(string: podcast.artworkUrl600 ?? "")
    }
    var trackCountString: String? {
        return "\(podcast.trackCount ?? 0) tane podcast var" //eğer öyle bisi yoksa ?? (ile) 0 yazsın dedik
    }
    var artistName: String? {
        return podcast.artistName
    }
    var trackName: String? {
        return podcast.trackName
    }
}
