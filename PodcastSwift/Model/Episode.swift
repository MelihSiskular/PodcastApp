//
//  Episode.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 1.02.2024.
//

import Foundation
import FeedKit

struct Episode: Codable { //Decodale olması önemli!
    let pubDate: Date
    let title: String
    let description: String
    let imageUrl : String
    let streamUrl: String
    let author: String
    var fileUrl: String?
    
    init(value: RSSFeedItem) { //bizim attığımız feedURL'den rss geliyordu. EpisodeService'de gördükl hatta value değerlerine ayrıştı
        //ben bu RSSFeedItem vericem daha kolaylık olsun diye tek tek girmemek için!
        self.author = value.iTunes?.iTunesAuthor?.description ?? value.author ?? ""
        self.pubDate = value.pubDate ?? Date()
        self.title = value.title ?? ""
        self.streamUrl = value.enclosure?.attributes?.url ?? ""
        self.description = value.iTunes?.iTunesSubtitle ?? value.description ?? "" //itunes subtitle da daha düzgün gözüküyor
        self.imageUrl = value.iTunes?.iTunesImage?.attributes?.href ?? "https://img.tamindir.com/2022/08/241137/podcast-nedir-podcast-onerileri.jpg"  //.href dediğimiz şey fotonun urlsi
                                                                                //yoksa bunlar olsun dedik (boş)
    }
}
