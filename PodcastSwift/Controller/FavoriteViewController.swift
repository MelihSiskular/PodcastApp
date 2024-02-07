//
//  FavoriteViewController.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 27.01.2024.
//

import Foundation
import UIKit

private let reuseIdentifier = "FavoriteCell"
class FavoriteViewController: UICollectionViewController {
    //MARK: - Properties
    private var resultsCoreDataItems: [PodcastCoreData] = []{
        didSet {
            collectionView.reloadData()
        }
    }
    //MARK: - Lifecycle
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let mainTabController = window.keyWindow?.rootViewController as! MainTabBarController
        mainTabController.viewControllers?[0].tabBarItem.badgeValue = nil //BİZDE 0. OLAN favorites kısmı, ARTIK BİLDİRİM VARSA ÜSTÜNE TIKLAYINCA GİDECEK!!!!!
        fetchData() //her girişte yeni favori varsa eklesin!
    }
}

//MARK: - Helpers
extension FavoriteViewController {
    private func fetchData() {
        let fetchRequest = PodcastCoreData.fetchRequest()
        CoreDataController.fetchCoreData(fetchRequest: fetchRequest) { results in
            self.resultsCoreDataItems = results
        }
    }
    private func setup() {
        view.backgroundColor = .white
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: reuseIdentifier) //collectionView tanımlaması
    }
}
 //MARK: - UICollectionViewDataSource
extension FavoriteViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resultsCoreDataItems.count // kaç tane fav varsa o kadar cell oluşsun
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoriteCell
        cell.podcastCoreData = self.resultsCoreDataItems[indexPath.item]
        return cell
    }
}
 //MARK: - UICollectionViewDelegate
extension FavoriteViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //cell'E tıklanınca yönlendirme olmalı!
        let podcastCoreData = self.resultsCoreDataItems[indexPath.item]
        let podcast = Podcast(trackName: podcastCoreData.trackName ,artistName: podcastCoreData.artistName!,artworkUrl600: podcastCoreData.artworkUrl600,feedUrl: podcastCoreData.feedUrl )
        let controller = EpisodeViewController(podcast: podcast)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


 //MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout { //her bi hücrenin yükseklik genişliği
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 50) / 2
        
        return .init(width: width, height: width + 50) //genişlik ekran / 2 kadar yani yatayda 2 hücre tamamen ekranıu kaplar, hegiht aşağı kaydırlamlı şekilde
        // - 30 olması sebebi soldan sağdan 10'ar ve iki hücre arası da zaten 10 yani totalde 30 boşluk var bunu cıkarayım ki ekrana iki tane hücre tam sığsın!
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { //hücrelerin kendi arasında dikeyde boşluğu
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { //hücreler arası yatayda boşluğu
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10) // her yerden bırakılan boşluk!
    }
}
