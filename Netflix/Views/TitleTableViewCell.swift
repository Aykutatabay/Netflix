//
//  TitleTableViewCell.swift
//  Netflix
//
//  Created by Aykut ATABAY on 31.01.2023.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let identifier = "TitleTableViewCell"
    
    let upcominImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let upcomingLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let upcomingPlayButtonView: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(upcominImageView)
        contentView.addSubview(upcomingLabelView)
        contentView.addSubview(upcomingPlayButtonView)
        
        applyConstarints()
    }
    
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstarints() {
        
        let upcomingImage = [
        
            upcominImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            upcominImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            upcominImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            upcominImageView.widthAnchor.constraint(equalToConstant: 120)
        ]
        let upcomingLabel = [
        
            upcomingLabelView.leadingAnchor.constraint(equalTo: upcominImageView.trailingAnchor, constant: 10),
            upcomingLabelView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        ]
        let upcomingButton = [
        
            upcomingPlayButtonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            upcomingPlayButtonView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        ]
        
        NSLayoutConstraint.activate(upcomingImage)
        NSLayoutConstraint.activate(upcomingLabel)
        NSLayoutConstraint.activate(upcomingButton)
        
    }
    
    public func configure(with model: TitleViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else { return }
        print("debug: configure worked \(url)")
        
        upcominImageView.sd_setImage(with: url)
        upcomingLabelView.text = model.titleName
    }
}
