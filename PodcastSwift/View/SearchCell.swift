//
//  SearchCell.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 30.01.2024.
//

import Foundation
import UIKit
import Kingfisher

class SearchCell: UITableViewCell {
    //MARK: - Properties
    
    var result: Podcast? {
        didSet { //içerisine veri geldiği zaman demek!
            configure()
        }
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .purple
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackName: UILabel = {
        let label = UILabel()
        label.text = "trackName"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let artistName: UILabel = {
        let label = UILabel()
        label.text = "artistName"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let trackCount: UILabel = {
        let label = UILabel()
        label.text = "trackCount"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private var stackView: UIStackView!
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - Helpers

extension SearchCell {
    private func setup() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.layer.cornerRadius = 12
        stackView = UIStackView(arrangedSubviews: [trackName,artistName,trackCount])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        addSubview(photoImageView)
        addSubview(stackView)
        NSLayoutConstraint.activate([ //Neyin nerde nası duracağı düzen işlemleri!
            
            photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 80),
            photoImageView.widthAnchor.constraint(equalToConstant: 80),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            
            stackView.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor,constant: 4),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    private func configure() {
        guard let result = self.result else {return}
        let viewModel = SearchViewModel(podcast: result) //SearchViewModel kullandık
                                                         //Aslında yine aynı şey oldu sadece daha düzgün gözüktü
                                                         //Tek bir erişimde istediğimize ulaştık onun arka planı daha karışık oldu biz basitçe çektik
        trackName.text = viewModel.trackName
        trackCount.text = viewModel.trackCountString
        artistName.text = viewModel.artistName
        photoImageView.kf.setImage(with: viewModel.photoImageUrl)
    }
}
