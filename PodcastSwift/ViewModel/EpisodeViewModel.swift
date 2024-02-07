//
//  EpisodeViewModel.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 1.02.2024.
//

import Foundation
struct EpisodeViewModel {
    let episode: Episode!
    init(episode: Episode!) {
        self.episode = episode
    }
    var profileImageUrl: URL? {
        return URL(string: episode.imageUrl)
    }
    var title: String {
        return episode.title
    }
    var description: String {
        return episode.description
    }
    var pubDate: String? { //pubDate normalde Date olarak geliyor ama biz burda SWtring şeklinde döncek dedik çünkü öyle yollicaz
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd , YYYY" //example Swift'te "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: episode.pubDate) //episode.pubDate dan gelen Dateyi stringe çevirdi!
    }
}
