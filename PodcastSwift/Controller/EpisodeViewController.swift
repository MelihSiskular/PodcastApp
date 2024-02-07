//
//  EpisodeViewController.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 31.01.2024.
//

import Foundation
import UIKit

private let reuseIdentifier = "EpisodeCell"
class EpisodeViewController: UITableViewController {
    //MARK: - Properties
    private var podcast: Podcast
    private var episodeResult: [Episode] = [] {
        didSet {
            self.tableView.reloadData() //bu episode dizisi her yenilendiğinde yani her bi cell'e girince istek atıcak ve yenilenecek
            
        }
    }
    private var isFavorite = false {
        didSet {
            setupNavBarItem()
        }
    }
    private var resultCoreDataItems: [PodcastCoreData] = [] {
        didSet {
            let isValue = resultCoreDataItems.contains(where: {$0.feedUrl == self.podcast.feedUrl}) //contain ile arama yaptık $0. ile elemanıma ulaştım!
            //benim seçtiğim eleman hangi sırada kaçıncı podcast elemanına denk geldi onun değeri ney onu aldık ve bize geln true false değerine göre işlem yaptık
            if isValue {
                isFavorite = true
            }else {
                isFavorite = false
            }
        }
    }
    //MARK: - Lifecycle
    init(podcast: Podcast) {
        self.podcast = podcast
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }
}

//MARK: - Selectors

extension EpisodeViewController {
    @objc func handleFavoriteButton() {
        
        if isFavorite {
            //silme işlemi
            deleteCoreData()
        }else {
            addCoreData() // yoksa ekleme işlemi yap
        }
        
    }
}

//MARK: - Helpers
extension EpisodeViewController {
    
    private func deleteCoreData() {
        CoreDataController.deleteCoreData(array: resultCoreDataItems, podcast: self.podcast)
        self.isFavorite = false //artık false oldu değer
    }
    
    private func addCoreData() { //model oluşturma, DİZİ ŞEKLİNDE SAKLAR!
        
        let model = PodcastCoreData(context: context) // artık entity içinde hangi değişkenler varsa modelden onlara ulaşıyoruz
        CoreDataController.addCoreData(model: model, podcast: self.podcast)
        isFavorite = true //eklendiğine göre isaFavorite = true
        
        //BADGE VALUE!!!!!!!!!
        let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let mainTabController = window.keyWindow?.rootViewController as! MainTabBarController
        mainTabController.viewControllers?[0].tabBarItem.badgeValue = "New" //BİZDE 0. OLAN favorites kısmı on da new diye badge çıkacaj!
        
    }
    
    private func fetchCoreData() {
        
        let fetchRequest = PodcastCoreData.fetchRequest()
        
        CoreDataController.fetchCoreData(fetchRequest: fetchRequest) { result in
            self.resultCoreDataItems = result
        }
        
    }
    private func setupNavBarItem() {
       
        if isFavorite {
            let navRightItem = UIBarButtonItem(image: UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(handleFavoriteButton))
            self.navigationItem.rightBarButtonItem = navRightItem //belki başka şeylerde ekleriz diye Items dedik ve [...] bıraktık!
            
        }else {
            let navRightItem = UIBarButtonItem(image: UIImage(systemName: "star")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(handleFavoriteButton))
            self.navigationItem.rightBarButtonItem = navRightItem //belki başka şeylerde ekleriz diye Items dedik ve [...] bıraktık!
          
        }
    }
    
    private func setup() {
        self.navigationItem.title = podcast.trackName 
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: reuseIdentifier)
        setupNavBarItem()
        fetchCoreData() //verileri getir! ilk açılırkende verilerle gelcek,
        //Core dataya veri ekleme silme işlemleri de ilgili yerlerde yapıldı
   
    }
}

//MARK: - Service(APİ)
extension EpisodeViewController {
    fileprivate func fetchData() {
        EpisodeService.fetchData(urlString: self.podcast.feedUrl!) { result in // -> @escaping() -> void şeklinde bir func olduğu için bişi döndürcek
                                                                               //Bu döndüreceği şeye result dedim, Episodelerdan oluşan bir dizi
            
            DispatchQueue.main.async {
                self.episodeResult = result
                //şimdi tüm feedURL isteğimizden gelen verilerileri [Episode] den oluşan dizimize aktardık ve episodeResult ile istediklermizi kullancaz!
            }
            
        }
    }
}

//MARK: - UITableViewDataSoruce
extension EpisodeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeResult.count // feedURL isteğinden kaç tane çekebildik.
      
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EpisodeCell
        cell.episode = self.episodeResult[indexPath.item]
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension EpisodeViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //episode'lara tıklanınca yani podcast bölümü açılınca nolcak!
        //print(self.episodeResult[indexPath.item].title)
        let choosenEpisode = self.episodeResult[indexPath.item] //seçilen episode'a ve bilgilerine ulaştık
        let controller = PlayerViewController(episode: choosenEpisode)
        self.present(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let downloadAction = UIContextualAction(style: .destructive, title: "Download") { action, view, completion in
            UserDefaults.downloadEpisodeWrite(episode: self.episodeResult[indexPath.item])
            EpisodeService.downloadEpisode(episode: self.episodeResult[indexPath.item]) //indirme işlemi!
            //BADGE VALUE!!!!!!!!!
            let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
            let mainTabController = window.keyWindow?.rootViewController as! MainTabBarController
            mainTabController.viewControllers?[2].tabBarItem.badgeValue = "New" //BİZDE 2. OLAN downloads kısmı on da new diye badge çıkacaj!
            completion(true) //true dediğimiz için tıkladıktan sonra kapar!
      
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [downloadAction])
        return configuration
    }
}
