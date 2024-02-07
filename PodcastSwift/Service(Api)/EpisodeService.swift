//
//  EpisodeService.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 31.01.2024.
//

import Foundation
import FeedKit
import Alamofire
struct EpisodeService {
    static func fetchData(urlString: String,completion: @escaping([Episode])-> Void) { //bu fonks [Episode] içinde Episode struck yapısında bi dizi yollayacak
        
        var episodeResult: [Episode] = []
        let feedKit = FeedParser(URL: URL(string: urlString)!)
        feedKit.parseAsync { result in
            switch result {
            case .success(let feed):
                switch feed {
                    
                case .atom(_):
                    break
                case .rss(let feedResult): //Bizim attığımız istekte rss yapısında olacağı için bunu kullancaz!
                    feedResult.items?.forEach({ value in
                        /*print(value.title) // foreach ile her değeri gezip value olarak atadı sonra valueyi bastırdık
                        print(value.pubDate)
                        print(value.description) */
                        //Verilerden bizim çekece
                        let episodeCell = Episode(value: value)
                        episodeResult.append(episodeCell)
                        completion(episodeResult)
                    })
                case .json(_):
                    break
                }
            
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }
    }
    
    static func downloadEpisode(episode: Episode) {
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        AF.download(episode.streamUrl, to: downloadRequest).downloadProgress { progress in //indirme durumunun progresini görebiliriz kullanabiliriz!
            let progressValue = progress.fractionCompleted
            NotificationCenter.default.post(name: .downloadNotificationName, object: nil,userInfo: ["title" : episode.title,"progress": progressValue])
        }.response { response in
            
            var downloadEpisodeResponse = UserDefaults.downloadEpisodeRead()
            let index = downloadEpisodeResponse.firstIndex(where: {$0.author == episode.author && $0.streamUrl == episode.streamUrl}) //elemanın indexini buluyoz
            downloadEpisodeResponse[index!].fileUrl =  response.fileURL?.absoluteString
            do {
                let data = try JSONEncoder().encode(downloadEpisodeResponse)
                UserDefaults.standard.set(data, forKey: UserDefaults.downloadKey) //yeni datayı güncelledik kaydettik
            }catch {
                
            }
        }
        
    }
}
