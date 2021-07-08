//
//  PlacemarkView.swift
//  TravelMap
//
//  Created by Даниил Петров on 08.07.2021.
//

import Foundation
import UIKit

class PlacemarkView: UIView {
    
    // MARK: - Properties

//    weak var delegate: MapViewDelegate?
    
    lazy var placemarkTitle: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название метки"
        textField.font = textField.font?.withSize(24)
        textField.clearButtonMode = .unlessEditing
        textField.backgroundColor = .systemBlue
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var placemarkSubtitle: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Описание метки"
        textField.font = textField.font?.withSize(18)
        textField.text = "asddasd"
        textField.clearButtonMode = .unlessEditing
        textField.backgroundColor = .systemBlue
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        addSubview(placemarkTitle)
        addSubview(placemarkSubtitle)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            placemarkTitle.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            placemarkTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            placemarkTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            placemarkTitle.heightAnchor.constraint(equalToConstant: 50),
            
            placemarkSubtitle.topAnchor.constraint(equalTo: placemarkTitle.bottomAnchor, constant: 36),
            placemarkSubtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            placemarkSubtitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            placemarkSubtitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Methods
}

// MARK: - Extensions


