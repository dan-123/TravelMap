//
//  PlaceViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 06.07.2021.
//

import Foundation
import UIKit

class PlaceViewController: UIInputViewController {
    
    // MARK: - Properties
    
    var placeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init

    init(placeLabelText: String) {
        super.init(nibName: nil, bundle: nil)
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        
        placeLabel.text = placeLabelText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupElements() {
        view.addSubview(placeLabel)
    }
    
    private func setupNavigationTools() {
        self.title = "Детальная информация"
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(addPhoto))
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            placeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            placeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            placeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            placeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Action
    
    @objc private func addPhoto() {
        print("добавление фото")
    }
    
}
