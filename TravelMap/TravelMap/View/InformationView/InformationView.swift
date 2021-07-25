//
//  InformationView.swift
//  TravelMap
//
//  Created by Даниил Петров on 23.07.2021.
//

import UIKit

class InformationView: UIView {
    
    // MARK: - Properties
    
    private let appImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "TravelMap"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var informationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElement()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupElement() {
        addSubview(appImageView)
        addSubview(informationLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            appImageView.widthAnchor.constraint(equalTo: appImageView.heightAnchor),
            appImageView.heightAnchor.constraint(equalToConstant: 100),
            appImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            appImageView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: appImageView.layoutMarginsGuide.bottomAnchor, constant: 8),
            informationLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 0),
            informationLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: 0),
            informationLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
        ])
    }
    
    // MARK: - Methods
    
    func setupText(text: String) {
        informationLabel.text = text
    }
}

