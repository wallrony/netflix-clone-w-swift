//
//  DownloadsViewController.swift
//  netflix-clone
//
//  Created by Rony on 16/11/22.
//

import UIKit

class DownloadsViewController: UIViewController, ParentViewController {
    private let viewModel: TitleViewModel
    private var titles = [Title]()
    
    private let loadingView = UIView()
    private let dataTable: UITableView = {
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
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        dataTable.delegate = self
        dataTable.dataSource = self
        
        loadTitles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dataTable.frame = view.frame
        loadingView.frame = view.frame
        
        setupLoadingIndicator()
    }
    
    private func setupLoadingIndicator() {
        let activityIndicator = self.loadingIndicator()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
        ])
    }
    
    private func loadTitles() {
        CacheManager.shared.fetchTitles(completion: { [weak self] result in
            switch (result) {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    guard self != nil else { return }
                    if self!.loadingView.isDescendant(of: self!.view) {
                        self?.loadingView.removeFromSuperview()
                    }
                    if !self!.dataTable.isDescendant(of: self!.view) {
                        self?.view.addSubview(self?.dataTable ?? UIView())
                    } else {
                        self?.dataTable.reloadData()
                    }
                }
                break
            case .failure(let error):
                print(error.message)
                break
            }
        })
    }
    
    private func loadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTitles()
    }
    
    func didTapItem(title: Title) {
        let vc = TitleDetailsViewController()
        vc.configure(with: title)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: self.titles[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            CacheManager.shared.deleteTitle(with: self.titles[indexPath.row], completion: { [weak self] result in
                switch result {
                case .success():
                    self?.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .right)
                    break
                case .failure(let error):
                    print(error.message)
                    break
                }
            })
            break
        case .insert:
            tableView.insertRows(at: [indexPath], with: .left)
            break
        default:
            break
        }
    }
}
