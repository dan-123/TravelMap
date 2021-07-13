//
//  CountryCollectionViewCell.swift
//  TravelMap
//
//  Created by Даниил Петров on 11.07.2021.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var countryImage: UIImageView = {
        let countryImage = UIImageView()
        countryImage.layer.cornerRadius = 10
        countryImage.contentMode = .scaleAspectFill
        countryImage.clipsToBounds = true
        countryImage.backgroundColor = .red
        countryImage.translatesAutoresizingMaskIntoConstraints = false
        return countryImage
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        clipsToBounds = true
//        autoresizesSubviews = true
        
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
            countryImage.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            countryImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            countryImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            countryImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Methods
    
    func setImage(_ image: UIImage?) {
        countryImage.image = image
    }
}
