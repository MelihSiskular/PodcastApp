//
//  MainTabBarController.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 27.01.2024.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension MainTabBarController {
    private func setup() {
        viewControllers = [
            createViewController(rootViewController: FavoriteViewController(), title: "Favorites", imagename: "play.circle.fill" ),
            createViewController(rootViewController: SearchViewController(), title: "Search", imagename: "magnifyingglass" ),
            createViewController(rootViewController: DownloadsViewController(), title: "Downloads", imagename: "square.stack.fill" ),
            //createViewController(rootViewController: FavoriteViewController(), title: "Extra", imagename: "infinity" )
        ]
        tabBar.tintColor = .systemPurple
        
    }
    
    private func createViewController(rootViewController: UIViewController, title: String, imagename: String) -> UINavigationController {
        rootViewController.title = title
        let apperance = UINavigationBarAppearance()
        apperance.configureWithDefaultBackground()
        let controller = UINavigationController(rootViewController: rootViewController)
        controller.navigationBar.prefersLargeTitles = true
        controller.navigationBar.compactAppearance = apperance
        controller.navigationBar.standardAppearance = apperance
        controller.navigationBar.scrollEdgeAppearance = apperance
        controller.navigationBar.compactScrollEdgeAppearance = apperance
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(systemName: imagename)

        return controller
    }
}
