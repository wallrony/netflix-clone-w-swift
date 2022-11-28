//
//  ViewController.swift
//  netflix-clone
//
//  Created by Rony on 16/11/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    private let viewModel = TitleViewModel(
        moviesService: MoviesService(adapter: MoviesAPI.shared),
        tvService: TVSevice(adapter: TVAPI.shared)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        tabBar.tintColor = .label
        
        let homeNav = UINavigationController(rootViewController: HomeViewController(viewModel: self.viewModel))
        let upcomingNav = UINavigationController(rootViewController: UpcomingViewController(viewModel: self.viewModel))
        let searchNav = UINavigationController(rootViewController: SearchViewController(viewModel: self.viewModel))
        let downloadsNav = UINavigationController(rootViewController: DownloadsViewController(viewModel: self.viewModel))
        
        homeNav.tabBarItem.image = UIImage(systemName: "house")
        homeNav.title = "Home"
        upcomingNav.tabBarItem.image = UIImage(systemName: "play.circle")
        upcomingNav.title = "Upcoming"
        searchNav.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchNav.title = "Search"
        downloadsNav.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        downloadsNav.title = "Downloads"
        
        setViewControllers([homeNav, upcomingNav, searchNav, downloadsNav], animated: true)
    }
}
