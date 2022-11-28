//
//  SearchResultsViewController.swift
//  netflix-clone
//
//  Created by Rony on 22/11/22.
//

import UIKit
import Combine

class SearchResultsViewController: UIViewController {
    private var titles = [Title]()
    private let viewModel: TitleViewModel
    private var subscriptions = [AnyCancellable]()
    weak var delegate: ParentViewController?
    
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
    
    private let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let viewWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: viewWidth / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
    }
    
    func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.searchResultsCollectionView.reloadData()
        }
    }
    
    private func download(indexPath: IndexPath) {
        let title = self.titles[indexPath.row]
        CacheManager.shared.saveTitle(title, completion: { result in
            switch (result) {
            case .success(()):
                print("Title \(title.name) downloaded")
                break
            case .failure(let error):
                print(error.message)
                break
            }
        })
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: titles[indexPath.row].posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { [weak self] _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self?.download(indexPath: indexPath)
            }
            return UIMenu(title: "Actions", image: nil, children: [downloadAction])
        }
        return config
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = self.titles[indexPath.row]
        self.delegate?.didTapItem(title: title)
    }
}
