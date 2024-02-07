//
//  CoreData+Helpers.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 4.02.2024.
//

import Foundation
import CoreData
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
struct CoreDataController {
    
   

    static func addCoreData(model: PodcastCoreData,podcast: Podcast) {
        model.feedUrl = podcast.feedUrl
        model.artistName = podcast.artistName
        model.trackName = podcast.trackName
        model.artworkUrl600 = podcast.artworkUrl600 //tüm modelleri atadık
        appDelegate.saveContext() //ve kaydettik
    }
    static func deleteCoreData(array: [PodcastCoreData],podcast: Podcast) {
        let value = array.filter({$0.feedUrl == podcast.feedUrl})
        context.delete(value.first!)
        appDelegate.saveContext()
    }
    static func fetchCoreData(fetchRequest:NSFetchRequest<PodcastCoreData>,completion: @escaping([PodcastCoreData])->Void) {
        do {
            let result = try context.fetch(fetchRequest)
            //resultCoreDataItems = result // çektiğimiz verileri, oluşturduğumuz [PodcastCoreData] dizisine attık!
            completion(result)
        }catch {
            
        }
    }
}
