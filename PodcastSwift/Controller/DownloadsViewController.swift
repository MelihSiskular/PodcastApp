//
//  DownloadsViewController.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 27.01.2024.
//

import Foundation
import UIKit
private let reuseIdentifier = "Download"
class DownloadsViewController: UITableViewController {
    
    //MARK: - Properties
    private var episodeResult = UserDefaults.downloadEpisodeRead() // bu şekilde verileri okuduk yani aldık kullancaz indirme varmı kaçtane var neler diye
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setNotificationCenter()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.episodeResult = UserDefaults.downloadEpisodeRead() //her açılırken bu işlem olsun
        tableView.reloadData()
        let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let mainTabController = window.keyWindow?.rootViewController as! MainTabBarController
        mainTabController.viewControllers?[2].tabBarItem.badgeValue = nil //BİZDE 2. OLAN downloads kısmı, ARTIK BİLDİRİM VARSA bu maintabbar sekmesine  TIKLAYINCA GİDECEK!!!!! nil'e eşitledik
    }
}

 //MARK: - Helpers
extension DownloadsViewController {
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownload), name: .downloadNotificationName, object: nil)
    }
    
    private func setup() {
        view.backgroundColor = .white
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: reuseIdentifier)

    }
    
  
}
 //MARK: - Selectors
extension DownloadsViewController {
    @objc
    private func handleDownload(notification: Notification) {
        //verileri Notification yapısında alacağız
        guard let response = notification.userInfo as? [String: Any] else {return}
        guard let title = response["title"] as? String else {return}
        guard let progressValue = response["progress"] as? Double else {return}
        guard let index = self.episodeResult.firstIndex(where: {$0.title == title}) else {return} //bizim titlemıza hangi title eşit ise onun indexini alacağız. İNDEX BULUNDU
        guard let cell = self.tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? EpisodeCell else {return}//cellimizi bulduk verdiğimiz indexten şimdi celli şekillendirme imklanımız var!
        cell.progressView.isHidden = false //progressView normalde gizli geliyor ama indirme olurken sadece onunkini açıyoruz
        cell.progressView.setProgress(Float(progressValue), animated: true) //responseden aldığımız sonucu kullancak!
        if progressValue >= 1 {
            cell.progressView.isHidden = true //dolduysa sakla gizle dedik! işi bitti
        }

    }
}
//MARK: - UITableViewDataSoruce
extension DownloadsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeResult.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EpisodeCell
        cell.episode = episodeResult[indexPath.item] //episode içindeki cell'lere gelen veriler giricek
        //biz episode cell'i öyle oluşturmuşuz Episode girmemiz yetiyor!
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension DownloadsViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PlayerViewController(episode: self.episodeResult[indexPath.item])
        self.present(controller, animated: true)
    }
}
