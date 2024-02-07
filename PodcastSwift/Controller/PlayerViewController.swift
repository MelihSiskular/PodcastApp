//
//  PlayerViewController.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 1.02.2024.
//

import Foundation
import UIKit
import AVKit

class PlayerViewController: UIViewController {
    //MARK: - Properties
    var episode: Episode
    
    private var mainStackView: UIStackView!
    
    private lazy var closeButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal) //aşağı kaydırma butonunun sistem adı
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        
        return button
    }()
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.customMode() //hep yaptığımız işlemleri kolaylık olsun diye bnuraya atmıştık!
        imageView.backgroundColor = .systemPurple
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    private let sliderView: UISlider = {
       let slider = UISlider()
        slider.setThumbImage(UIImage(), for: .normal) //sliderda o hareket eden top yerine image koyabiliriz ama bizde ihtiyaç yok ona o yüzden coş verdik!
        slider.tintColor = .systemPurple
        return slider
    }()
    private let startLabel: UILabel = {
        let label = UILabel()
        label.text = "00 : 00"
        label.textAlignment = .left
        return label
    }()
    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = "00 : 00"
        label.textAlignment = .right
        return label
    }()
    private let podcastLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.textAlignment = .center
        return label
    }()
    private let userLabel: UILabel = {
        let label = UILabel()
        label.text = "user"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        return label
    }()
    private lazy var goForWard: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "goforward.30"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(handleGoForWard), for: .touchUpInside)
        return button
    }()
    private lazy var goPlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.addTarget(self, action: #selector(handleGoPlayButton), for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    private lazy var goBackWard: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "gobackward.30"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(handleGoBackWard), for: .touchUpInside)
        return button
    }()
    private lazy var volumeSliderView: UISlider = {
       let slider = UISlider()
        slider.tintColor = .systemPurple
        slider.minimumValue = 0
        slider.maximumValue = 100 //min ve max ne kadar olabilir onu belirledik!
        slider.addTarget(self, action: #selector(handleVolumeSlider), for: .valueChanged) //her değer değişince bu tetiklenecek!
        return slider
    }()
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.plus.fill")
        imageView.tintColor = .lightGray
        return imageView
    }()
    private let minusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.minus.fill")
        imageView.tintColor = .lightGray
        return imageView
    }()
    private let player: AVPlayer = {
       let player = AVPlayer()
        
        return player
    }()
    
    private var fullTimerStackView: UIStackView!
    private var playStackView: UIStackView!
    private var timerStackView: UIStackView!
    private var volumeStackView: UIStackView!
    //MARK: - Lifecycle
    init(episode: Episode) {
        self.episode = episode //class ve bişey tanımladık yani burdan bize kesin bi episode gelcek ve bu episode da cell'E tıklanınca ordaki episode neyse o gelcek
        super.init(nibName: nil, bundle: nil)
        style()
        layout()
        startPlay()
        configureUI()
    }
    override func viewDidDisappear(_ animated: Bool) { // sayfa tamamen kapanırkende playerin durması lazım yoksa devam ediyor!
        super.viewDidDisappear(animated)
        player.pause()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Selectors
extension PlayerViewController {
    
    @objc private func handleVolumeSlider(_ sender: UISlider) {
        player.volume = sender.value //slider bi değer döndürcek buna sender'dan ulaşıcaz!
        
    }
    
    @objc private func handleGoPlayButton() {
        if player.timeControlStatus == .paused { //eğer çalım duruyor ise
            player.play()
            self.goPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)

        }else {// çalmaya devam ediyorken tıklanırsa
            player.pause()
            self.goPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)

        }
    }
    
    @objc private func handleCloseButton() {
        player.pause()
        self.dismiss(animated: true)
    }
    
    @objc private func handleGoForWard() {
        let exampleTime = CMTime(value: 30, timescale: 1) //30 saniye ilerlesin dedik timesclae 2 iken nedense 15er 15er artıyp
        let seekTime = CMTimeAdd(player.currentTime(), exampleTime) //bu ilerleme nereye eklenecek belirttik currentTime yani nerdeysek onun üstüne
        player.seek(to: seekTime) //o zamana player geçeecek
    }
    @objc private func handleGoBackWard() {
        let exampleTime = CMTime(value: -30, timescale: 1) //30 saniye geriye sarar
        let seekTime = CMTimeAdd(player.currentTime(), exampleTime)
        player.seek(to: seekTime)
    }
}
//MARK: - Helpers
extension PlayerViewController {
    
    fileprivate func updateSlider() {
        let currentTimeSecond = CMTimeGetSeconds(player.currentTime())
        let durationTime = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let resultSecondTime = currentTimeSecond / durationTime
        self.sliderView.value = Float(resultSecondTime)
    }
    
    fileprivate func updateTimeLabel() {
        let interval = CMTime(value: 1, timescale: 2) //value parametresi zaman dilimindeki değeri, timescale ise bu değerin saniye cinsinden birimini belirtir. Bu örnekte, value 1 ve timescale 2 olarak ayarlandığından, zaman dilimi 0.5 saniyedir. !!!!!!!!!!!!!!!
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            /*let totalSecond = Int(CMTimeGetSeconds(time))
            let second = totalSecond % 60
            let minutes = totalSecond / 60
            let formatString = String(format: "%02d : %02d", minutes,second) */
            self.startLabel.text = time.formatString() //CMTime için extension yazdık artık o işlemleri direk halledicek!
            let endTimeSecond = self.player.currentItem?.duration
            self.endLabel.text = endTimeSecond?.formatString()
            self.updateSlider()
        }
    }
    
    private func playPlayer(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play() //çalışmaya başlat
        //Podcast çalışmaya başlarsa oynat yerine durdur gözükmesi gerekir!
        self.goPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        volumeSliderView.value = 40// başlangıc değeri sesin
        updateTimeLabel()
    }
    
    private func startPlay() {
        
        if episode.fileUrl != nil { //Eğerki bizim geçiş yaptığımız episode daha önce fileurlsi oluştuysa yani indirildiyse bu olcak!
            guard let url = URL(string: episode.fileUrl ?? "") else {return}
            guard var fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            fileUrl.append(path: url.lastPathComponent)
            playPlayer(url: fileUrl)
            return
        }
        
        
        
        guard let url = URL(string: episode.streamUrl) else {return} //URL KONTROLÜ! bizim episodedan gelcek bu veri
        playPlayer(url: url)
    }
    
    private func style() {
        view.backgroundColor = .white
        
        timerStackView = UIStackView(arrangedSubviews: [startLabel,endLabel])
        timerStackView.axis = .horizontal
        
        fullTimerStackView = UIStackView(arrangedSubviews: [sliderView,timerStackView])
        fullTimerStackView.axis = .vertical
        
        playStackView = UIStackView(arrangedSubviews: [UIView(),goBackWard,UIView(),goPlayButton,UIView(),goForWard,UIView()])
        playStackView.axis = .horizontal
        playStackView.distribution = .fillEqually // stackler arası ayrılıklar için!
        
        volumeStackView = UIStackView(arrangedSubviews: [minusImageView,volumeSliderView,plusImageView])
        volumeStackView.axis = .horizontal
        mainStackView = UIStackView(arrangedSubviews: [closeButton,episodeImageView,fullTimerStackView,UIView(),podcastLabel,userLabel,UIView(),playStackView,volumeStackView]) //arlarada UIView() verme sebebimiz boşluk olması için
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        print(episode.title)
    }
    private func layout() {
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            episodeImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            sliderView.heightAnchor.constraint(equalToConstant: 40),
            playStackView.heightAnchor.constraint(equalToConstant: 80),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),  //sol-sağ sınırları!
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -32)
        ])
        
    }
    private func configureUI() {
        self.episodeImageView.kf.setImage(with: URL(string: episode.imageUrl))
        self.podcastLabel.text = episode.title
        self.userLabel.text = episode.author
    }
}
