//
//  Search.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 30.01.2024.
//

import Foundation

struct Search: Decodable {
    let resultCount: Int
    let results: [Podcast]
}

//Bize gelen jsonda isimleri nasılsa aynen öyle olmalı!
struct Podcast: Decodable {
    var trackName: String?
    var artistName: String
    var trackCount: Int?
    var artworkUrl600: String?
    var feedUrl : String?
}
