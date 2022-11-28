//
//  SearchViewController.swift
//  netflix-clone
//
//  Created by Rony on 16/11/22.
//

import UIKit
import Combine

class SearchViewController: UIViewController, ParentViewController {
    private let viewModel: TitleViewModel
    private var titles = [Title]()
    private var subscriptions = [AnyCancellable]()

    private let loadingView = UIView()
    private let dataTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private var searchController: UISearchController?
    
    init(viewModel: TitleViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        setupSearchController()
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
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        
        view.addSubview(loadingView)
        
        dataTable.delegate = self
        dataTable.dataSource = self
        
        self.searchController?.searchResultsUpdater = self
    }
    
    private func setupSearchController() {
        let searchResultsController = SearchResultsViewController(viewModel: viewModel)
        searchResultsController.delegate = self
        let controller = UISearchController(searchResultsController: searchResultsController)
        controller.searchBar.placeholder = "Search for a movie or a TV show"
        controller.searchBar.searchBarStyle = .prominent
        self.searchController = controller
        setupSubscriptions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dataTable.frame = view.bounds
        loadingView.frame = view.bounds
        
        setupLoadingIndicator()
    }
    
    private func setupLoadingIndicator() {
        let indicator = self.loadingIndicator()
        loadingView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
        ])
    }
    
    private func loadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    private func setupSubscriptions() {
        viewModel.discoverMoviesPublisher.sink(receiveValue: { [weak self] movies in
            if movies != nil {
                self?.titles = movies!.map(Title.Movie)
                DispatchQueue.main.async {
                    guard self != nil else { return }
                    if self!.loadingView.isDescendant(of: self!.view) {
                        self?.loadingView.removeFromSuperview()
                    }
                    if !self!.dataTable.isDescendant(of: self!.view) {
                        self?.view.addSubview(self?.dataTable ?? UIView())
                    } else {
                        self!.dataTable.reloadData()
                    }
                }
            } else {
                self?.viewModel.fetchDiscoverMovies()
            }
        }).store(in: &subscriptions)
        
        self.viewModel.searchedMoviesPublisher.sink(receiveValue: { [weak self] movies in
            guard let searchResultsControllerView = self?.searchController?.searchResultsController as? SearchResultsViewController else {
                return
            }
            let titles = movies?.map(Title.Movie) ?? []
            searchResultsControllerView.configure(with: titles)
        }).store(in: &subscriptions)
    }
    
    func didTapItem(title: Title) {
        let vc = TitleDetailsViewController()
        vc.configure(with: title)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: self.titles[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let _ = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        viewModel.searchMovies(with: query)
    }
}
