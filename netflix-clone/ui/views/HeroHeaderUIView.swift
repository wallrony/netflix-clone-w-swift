//
//  HelloHeaderUIView.swift
//  netflix-clone
//
//  Created by Rony on 16/11/22.
//

import UIKit

class HeroHeaderUIView: UIView {
    private var title: Title?
    weak var delegate: ParentViewController?
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func applyConstraints() {
        let playButtonConstraints = [
            playButton.centerXAnchor.constraint(equalTo: heroImageView.centerXAnchor, constant: -62.5),
            playButton.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: -25),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: heroImageView.centerXAnchor, constant: 62.5),
            downloadButton.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: -25),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heroImageView.frame = bounds
    }
    
    func configure(with title: Title) {
        self.title = title
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(title.posterPath)") else { return }
        heroImageView.sd_setImage(with: imageURL)
        downloadButton.addAction(UIAction(handler: { _ in
            guard self.title != nil else { return }
            CacheManager.shared.saveTitle(title, completion: { result in })
        }), for: .touchDown)
        playButton.addAction(UIAction(handler: { _ in
            self.delegate?.didTapItem(title: title)
        }), for: .touchDown)
    }
}
