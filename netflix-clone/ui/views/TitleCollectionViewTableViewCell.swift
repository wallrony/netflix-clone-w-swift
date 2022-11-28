//
//  CollectionViewTableViewCell.swift
//  netflix-clone
//
//  Created by Rony on 16/11/22.
//

import UIKit

protocol ParentViewController: AnyObject {
    func didTapItem(title: Title)
}

class TitleCollectionViewTableViewCell: UITableViewCell {
    static let identifier: String = "MovieCollectionViewTableViewCell"
    weak var delegate: ParentViewController?
    
    private var titles = [Title]()
    
    private let loadingView = UIView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .gray.withAlphaComponent(0.5)
        contentView.addSubview(loadingView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
        loadingView.frame = contentView.bounds
        
        let activityIndicator = self.loadingIndicator()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
        ])
    }
    
    func configure(with titles: [Title]) {
        self.titles = titles
        loadingView.removeFromSuperview()
        if collectionView.isDescendant(of: contentView) {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        } else {
            contentView.addSubview(collectionView)
        }
    }
    
    private func loadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
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

extension TitleCollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: self.titles[indexPath.row].posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
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
        let title = self.titles[indexPath.row]
        self.delegate?.didTapItem(title: title)
    }
}
