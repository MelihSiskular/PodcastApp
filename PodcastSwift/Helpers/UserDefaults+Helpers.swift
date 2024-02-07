//
//  UserDefaults+Helpers.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 7.02.2024.
//

import Foundation

extension UserDefaults {
    
    static let downloadKey = "downloadedKey"
    
    static func downloadEpisodeWrite(episode: Episode) {
        do {
            var resultEpisodes = downloadEpisodeRead()
            resultEpisodes.append(episode)
            let data = try JSONEncoder().encode(resultEpisodes) //yeni eklenmiş yazılmış halini yazdırdık
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadKey) // içeri kaydetme işlemi
        }catch {
            
        }
    }
    static func downloadEpisodeRead() -> [Episode] {
        
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.downloadKey) else {return []}
        do {
            let resultData = try JSONDecoder().decode([Episode].self, from: data)
            return resultData //okuma işlmei!
        }catch {
            
        }
        
        return []
    }
}
