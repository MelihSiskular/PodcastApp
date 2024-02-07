//
//  FavoriteCellViewModel.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 4.02.2024.
//

import Foundation
struct FavoriteCellViewModel {
    var podcastCoreData: PodcastCoreData!
    init(podcastCoreData: PodcastCoreData!) {
        self.podcastCoreData = podcastCoreData
    }
    var imageUrlPodcast: URL? {
        return URL(string: podcastCoreData.artworkUrl600!) //kesin gelcek
    }
    var podcastName: String? {
        return podcastCoreData.trackName
    }
    var artisttName: String? {
        return podcastCoreData.artistName
    }
}
