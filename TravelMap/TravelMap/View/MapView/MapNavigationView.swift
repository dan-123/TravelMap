//
//  MapNavigationView.swift
//  TravelMap
//
//  Created by Даниил Петров on 19.07.2021.
//

import Foundation
import  UIKit

protocol MapNavigationViewDelegate: AnyObject {
    func tappedBackButton()
    func tappedAddButton() -> MapMode
}

class MapNavigationView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: MapNavigationViewDelegate?
    
    private let buttonDiameter: CGFloat = 80
    private let imageSize: CGFloat = 30
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowshape.turn.up.backward.circle.fill")
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle.fill")
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        addSubview(backButton)
        backButton.addSubview(backButtonImage)
        addSubview(addButton)
        addButton.addSubview(addButtonImage)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -15),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            backButtonImage.centerXAnchor.constraint(equalTo: backButton.centerXAnchor),
            backButtonImage.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            addButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 15),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            addButtonImage.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            addButtonImage.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
    }
        
    // MARK: - Action
    
    @objc private func tappedBackButton() {
        delegate?.tappedBackButton()
    }
    
    @objc private func tappedAddButton() {
        let mapMode = delegate?.tappedAddButton()
        switch mapMode {
        case .globalMode:
            addButtonImage.image = UIImage(systemName: "plus.circle.fill")
        case .localMode:
            addButtonImage.image = UIImage(systemName: "mappin.circle.fill")
        case .none:
            break
        }
    }
        
    // MARK: - Methods
    
//    private func setupButton(_ button: UIButto) -> UIButton {
//        button.layer.cornerRadius = 30
//        button.backgroundColor = .systemBlue
//        button.layer.borderColor = UIColor.black.cgColor
//        button.layer.borderWidth = 1
//        button.addTarget(self, action: #selector(<#T##@objc method#>), for: <#T##UIControl.Event#>)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }
//
//    private func imageForButton(imageView: UIImageView, image: String) -> UIImageView {
//        imageView.image = UIImage(systemName: image)
//        imageView.contentMode = .scaleToFill
//        imageView.tintColor = .white
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }
}
