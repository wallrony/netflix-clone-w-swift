//
//  HomeViewController.swift
//  netflix-clone
//
//  Created by Rony on 16/11/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController, ParentViewController {
    private let viewModel: TitleViewModel
    private var headerView: HeroHeaderUIView?
    private var subscriptions = [AnyCancellable]()
    
    let sections = [
        TitleSection.Movie("trending movies", classification: MovieClassification.Trending),
        TitleSection.TV("trending tvs", classification: TVClassification.Trending),
        TitleSection.Movie("popular", classification: MovieClassification.Popular),
        TitleSection.Movie("upcoming movies", classification: MovieClassification.Upcoming),
        TitleSection.Movie("top rated", classification: MovieClassification.TopRated),
    ]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TitleCollectionViewTableViewCell.self, forCellReuseIdentifier: TitleCollectionViewTableViewCell.identifier)
        return table
    }()
    
    init(viewModel: TitleViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel = TitleViewModel(
            moviesService: MoviesService(adapter: MoviesAPI.shared),
            tvService: TVSevice(adapter: TVAPI.shared)
        )
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 475))
        headerView?.delegate = self
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.tableHeaderView = headerView
        
        configureNavBar()
        configureHeaderView()
    }
    
    private func configureNavBar() {
        let image = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .systemBackground == UIColor.white ? UIColor.black : UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func configureHeaderView() {
        self.viewModel.trendingMoviesPublisher.sink(receiveValue: { [weak self] movies in
            if movies != nil {
                guard let movie = movies!.randomElement() else {
                    return
                }
                self?.headerView?.configure(with: Title.Movie(movie))
            }
        }).store(in: &subscriptions)
    }
    
    func didTapItem(title: Title) {
        let vc = TitleDetailsViewController()
        vc.configure(with: title)
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private func loadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleCollectionViewTableViewCell.identifier, for: indexPath) as? TitleCollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        return self.viewModel.fillTableViewCellSection(section: section, cell: cell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection index: Int) -> String? {
        return sections[index].name
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 30, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white.withAlphaComponent(0.8)
        header.textLabel?.text = header.textLabel?.text?.captalizeFirstLetter()
    }
}
