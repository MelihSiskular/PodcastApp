//
//  FavoriteCell.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 3.02.2024.
//

import Foundation
import UIKit
class FavoriteCell : UICollectionViewCell {
    //MARK: - Properties
    var podcastCoreData: PodcastCoreData?{
        didSet {
            configure()
        }
    }
    private let podcastImageaView: UIImageView = {
       let imageView = UIImageView()
        imageView.customMode()
        imageView.backgroundColor = .systemPurple
        return imageView
        
    }()
    private let podcastNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Podcast Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    private let artisttNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Artist Name"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    private var fullStackView: UIStackView!
    
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

 //MARK: - Helpers
extension FavoriteCell {
    private func configure() {
        guard let podcastCoreData = self.podcastCoreData else {return} //geldi mi diye kontrol
        let viewModel = FavoriteCellViewModel(podcastCoreData: podcastCoreData)
        self.podcastImageaView.kf.setImage(with: viewModel.imageUrlPodcast)
        self.podcastNameLabel.text = viewModel.podcastName
        self.artisttNameLabel.text = viewModel.artisttName
        
    }
    private func style() {
        fullStackView = UIStackView(arrangedSubviews: [podcastImageaView,podcastNameLabel,artisttNameLabel])
        fullStackView.axis = .vertical
        fullStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        addSubview(fullStackView)
        NSLayoutConstraint.activate([
            podcastImageaView.heightAnchor.constraint(equalTo: podcastImageaView.widthAnchor),
            
            fullStackView.topAnchor.constraint(equalTo: topAnchor),
            fullStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fullStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            fullStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
