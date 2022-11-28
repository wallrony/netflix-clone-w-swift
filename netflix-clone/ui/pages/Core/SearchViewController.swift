//
//  SearchViewController.swift
//  netflix-clone
//
//  Created by Rony on 16/11/22.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    private let viewModel: TitleViewModel
    private var titles = [Title]()
    private var subscriptions = [AnyCancellable]()

    private let loadingView = UIView()
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
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
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(loadingView)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
        loadingView.frame = view.bounds
        
        viewModel.discoverMoviesPublisher.sink(receiveValue: { [weak self] movies in
            if movies != nil {
                self?.titles = movies!.map(Title.Movie)
                DispatchQueue.main.async {
                    self?.loadingView.removeFromSuperview()
                    self?.view.addSubview(self?.discoverTable ?? UIView())
                    self?.subscriptions.first?.cancel()
                }
            } else {
                self?.viewModel.fetchDiscoverMovies()
            }
        }).store(in: &subscriptions)
        
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
