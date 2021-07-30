//
//  CountryCollectionViewCell.swift
//  TravelMap
//
//  Created by Даниил Петров on 11.07.2021.
//

import UIKit

final class CountryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var countryImage: UIImageView = {
        let countryImage = UIImageView()
        countryImage.layer.cornerRadius = 10
        countryImage.contentMode = .scaleAspectFill
        countryImage.clipsToBounds = true
        countryImage.backgroundColor = .gray
        countryImage.translatesAutoresizingMaskIntoConstraints = false
        return countryImage
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
        contentView.addSubview(countryImage)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            countryImage.topAnchor.constraint(equalTo: topAnchor),
            countryImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            countryImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            countryImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Methods
    
    func setImage(_ image: UIImage?) {
        countryImage.image = image
    }
}
