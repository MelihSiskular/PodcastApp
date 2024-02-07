//
//  EpisodeCell.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 31.01.2024.
//

import Foundation
import UIKit

class EpisodeCell: UITableViewCell {
    //MARK: - Properties
    
    var episode: Episode? {
        didSet { //episode yapısı gelirse çalıştır
            configure()
        }
    }
    
    var progressView: UIProgressView = { //bunu private tanımlamıyorum baska yerde kullanılcak
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .lightGray
        progressView.tintColor = .systemPurple
        progressView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner] // özel olarak bunları işleme sokacaj
        progressView.layer.cornerRadius = 12 //çok düz oluyorud biraz aşağısı kıvrım kçseşi toplansın
        progressView.setProgress(Float(0), animated: true)
        progressView.isHidden = true //başta gizli olcak!
        return progressView
    }()
    
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.customMode() //imageView UIImageView classından bir obje bu yüzden o sınıfa ait func'lara erişti bizde oraya exztension yazdık!
        imageView.backgroundColor = .systemPurple
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    private let pubDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPurple
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "pubDateLabel"
        label.numberOfLines = 2
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPurple
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "titleLabel"
        label.numberOfLines = 2

        return label
    }()
    
    private let decriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "DecriptionLabel"
        label.numberOfLines = 2

        return label
    }()
    private var stackView: UIStackView!
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Helpers
extension EpisodeCell {
    private func setup() {
        configureUI()
    }
    private func configureUI() {
        episodeImageView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false //auto düzenleme yapma biz kendimiz yapcaz diyoruz bu şekilde!
        addSubview(episodeImageView)
        addSubview(progressView)
        NSLayoutConstraint.activate([
            episodeImageView.heightAnchor.constraint(equalToConstant: 100),
            episodeImageView.widthAnchor.constraint(equalToConstant: 100),
            episodeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            episodeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            progressView.heightAnchor.constraint(equalToConstant: 20),
            progressView.leadingAnchor.constraint(equalTo: episodeImageView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: episodeImageView.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: episodeImageView.bottomAnchor), // progressViewı imageye bağlı yaptık
        ])
        stackView = UIStackView(arrangedSubviews: [pubDateLabel,titleLabel,decriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3 //stackViewdaki her bir eleman arasında 5 boşluk olsun dedik!
        stackView.axis = .vertical
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: episodeImageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10)
        ])
    }
    
    private func configure() {
        guard let episode = self.episode else {return} //episodenin gelip gelmediğini kontrol ettik!
        let episodeViewModel = EpisodeViewModel(episode: episode) //bize gelen episode modele aktardık model çalışırken o episode. xxxx dan çekecek
        self.episodeImageView.kf.setImage(with: episodeViewModel.profileImageUrl)
        self.titleLabel.text = episodeViewModel.title //titlelar episodedan gelen title olcak ama hangi sırada ne olacağını bilmek için cellforRowAt te indexpath!!
        self.decriptionLabel.text = episodeViewModel.description
        self.pubDateLabel.text = episodeViewModel.pubDate
    }
}
