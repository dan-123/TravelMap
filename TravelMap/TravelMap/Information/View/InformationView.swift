//
//  InformationView.swift
//  TravelMap
//
//  Created by Даниил Петров on 23.07.2021.
//

import UIKit

final class InformationView: UIView {
    
    // MARK: - Properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.scrollsToTop = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(appImageView)
        contentView.addSubview(informationLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        let heightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor)
        heightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            heightConstraint
        ])
        
        NSLayoutConstraint.activate([
            appImageView.widthAnchor.constraint(equalTo: appImageView.heightAnchor),
            appImageView.heightAnchor.constraint(equalToConstant: 100),
            appImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            appImageView.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: appImageView.layoutMarginsGuide.bottomAnchor, constant: 8),
            informationLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            informationLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Methods
    
    func setupText(text: String) {
        informationLabel.text = text
    }
}
