//
//  TitleDetailsViewController.swift
//  netflix-clone
//
//  Created by Rony on 28/11/22.
//

import UIKit

class TitleDetailsViewController: UIViewController {
    private var titleObj: Title?
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let downloadButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 8
        btn.setTitle("Download", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemRed
        return btn
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = self.titleObj?.name ?? ""
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(posterImageView)
        view.addSubview(downloadButton)
        view.addSubview(overviewLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func configure(with title: Title) {
        self.titleObj = title
        configurePosterImageView()
        configureDownloadButton()
        configureOverviewLabel()
    }
    
    private func configurePosterImageView() {
        guard self.titleObj != nil else { return }
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(titleObj!.posterPath)") else { return }
        posterImageView.sd_setImage(with: url)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.5)
        ])
    }
    
    private func configureDownloadButton() {
        downloadButton.addAction(UIAction(handler: { _ in
            self.downloadTitle()
        }), for: .touchDown)
        
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 15),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 125)
        ])
    }
    
    private func configureOverviewLabel() {
        guard self.titleObj != nil else { return }
        overviewLabel.text = self.titleObj!.overview
        overviewLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func downloadTitle() {
        guard self.titleObj != nil else { return }
        CacheManager.shared.saveTitle(self.titleObj!, completion: { [weak self] result in
            switch (result) {
            case .success(()):
                print("Title \(self?.titleObj!.name ?? "") downloaded")
                break
            case .failure(let error):
                print(error.message)
                break
            }
        })
    }
}
