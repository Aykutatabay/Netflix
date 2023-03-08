//
//  HeroHeaderUIView.swift
//  Netflix
//
//  Created by Aykut ATABAY on 30.01.2023.
//

import UIKit
import SDWebImage

class HeroHeaderUIView: UIView {
    
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    private let playbutton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
        
        
    }()
    
    private let heroImageVew: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "pulpFiction")
        return imageView
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageVew)
        addGradient()
        addSubview(playbutton)
        addSubview(downloadButton)
        applyConstrains()
        
        
    }
    
    public func configure (with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else { return }
        
        heroImageVew.sd_setImage(with: url, completed: nil)
        
    }

    
    private func applyConstrains() {
        let playButtonConstrains = [
            playbutton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            playbutton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playbutton.widthAnchor.constraint(equalToConstant: 120)
        
        ]
        NSLayoutConstraint.activate(playButtonConstrains)
        
        let downloadButtonConstrains = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        
        ]
        NSLayoutConstraint.activate(downloadButtonConstrains)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageVew.frame = bounds
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }

}
