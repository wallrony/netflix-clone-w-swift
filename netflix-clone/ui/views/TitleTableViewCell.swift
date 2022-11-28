//
//  TitleTableViewCell.swift
//  netflix-clone
//
//  Created by Rony on 21/11/22.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {
    static let identifier = "TitleTableViewCell"
    weak var delegate: ParentViewController?
    
    private var title: Title?
    
    private let playBtn: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        btn.setImage(image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playBtn)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        let posterConstraints = [
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.5),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.5),
            posterImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        let playBtnConstraints = [
            playBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playBtn.widthAnchor.constraint(equalToConstant: 40)
        ]
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: posterImage.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: playBtn.leadingAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(posterConstraints)
        NSLayoutConstraint.activate(playBtnConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    func configure(with title: Title) {
        self.title = title
        
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(title.posterPath)") else { return }
        posterImage.sd_setImage(with: imageURL)
        titleLabel.text = title.name
        playBtn.addAction(UIAction(handler: { _ in
            self.delegate?.didTapItem(title: title)
        }), for: .touchDown)
    }
}
