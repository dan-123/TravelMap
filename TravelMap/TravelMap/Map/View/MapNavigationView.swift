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
    func tappedAddButton()
}

class MapNavigationView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: MapNavigationViewDelegate?
    
    private let buttonDiameter: CGFloat = 80
    private let imageSize: CGFloat = 30
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBackground
        button.tintColor = .systemBlue
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.alpha = 0.65
        button.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward.circle"), for: .normal)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward.circle.fill"), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBackground
        button.tintColor = .systemBlue
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.alpha = 0.65
        button.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .highlighted)
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
        addSubview(backButton)
        addSubview(addButton)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -12),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            addButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 12),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
        
    // MARK: - Action
    
    @objc private func tappedBackButton() {
        delegate?.tappedBackButton()
    }
    
    @objc private func tappedAddButton() {
        delegate?.tappedAddButton()
    }
}
