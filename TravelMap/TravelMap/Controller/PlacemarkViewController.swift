//
//  PlacemarkViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 06.07.2021.
//

import Foundation
import UIKit

class PlacemarkViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var placemarkInfo: PlacemarkView = {
        placemarkInfo = PlacemarkView()
        placemarkInfo.translatesAutoresizingMaskIntoConstraints = false
        return placemarkInfo
    }()
    
    // MARK: - Init

    init(placeLabelText: String) {
        super.init(nibName: nil, bundle: nil)
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        view.backgroundColor = .systemBackground
        
        placemarkInfo.placemarkSubtitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editSubtitle)))
//        placeLabel.text = placeLabelText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupElements() {
        view.addSubview(placemarkInfo)
    }
    
    private func setupNavigationTools() {
        self.title = "Информация о метке"
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(addPhoto))
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            placemarkInfo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            placemarkInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            placemarkInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            placemarkInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Action
    
    @objc private func addPhoto() {
        print("добавление фото")
    }
    
    @objc private func editSubtitle(gesture: UITapGestureRecognizer) {
        print("редактирование описания")
    }
    
}
