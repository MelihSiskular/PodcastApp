//
//  SearchViewController.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 27.01.2024.
//

import Foundation
import UIKit
import Alamofire

private let  reuseIdentifer = "SearchCell"

class SearchViewController: UITableViewController {
    
    var searchResult: [Podcast] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension SearchViewController {
    
    private func style() {
        tableView.register(SearchCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.rowHeight = 130
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false //ilk açıldığında gözükmüyor gözükmesi için yaptık ve kaydırma işleminde
        searchController.searchBar.delegate = self //içine yazılanı kulanmak için
    }
    
    private func layout() {
        
    }
}

//MARK: - UItableViewDataSource
extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer,for: indexPath) as! SearchCell
        
        cell.result = self.searchResult[indexPath.row]
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SearchViewController { //HEADER EKLEDİK
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Start Searching All Podcast..."
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = .systemPurple
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.searchResult.count == 0 ? 80:0 //count 0'a eşit ise 80 yap değilse 0 yap dedik
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //cell'E tıklanınca nolcak
        let podcast = self.searchResult[indexPath.row]
        let controller = EpisodeViewController(podcast: podcast)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate { //searbar delegateyi dahil et
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchService.fetchData(searchText: searchText) { result in
            self.searchResult = result
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { //Searchbardan çıkınca nolcak işlemeri
        self.searchResult = [] //arama yerinden çıkınca yazılanlar silinmiş oluyor
                               // YANİ EKRANDA ESKİ ARANANLARIN GÖZÜKMESİNE GEREK YOK!
                               // çektiğimiz verileri boşalt ki bişi göstermesin bize!
    }
}
