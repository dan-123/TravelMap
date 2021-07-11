//
//  MapSettingView.swift
//  TravelMap
//
//  Created by Даниил Петров on 10.07.2021.
//

import UIKit

class MapSettingView: UIView {
    
    // MARK: - Properties

//    weak var delegate: MapViewDelegate?
    
    lazy var countryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Добавить страну", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cityButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Добавить город", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        addSubview(countryButton)
        addSubview(cityButton)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            countryButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            countryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            countryButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            countryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            cityButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            cityButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            cityButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            cityButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
