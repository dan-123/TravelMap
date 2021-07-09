//
//  ThirdViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit

class ThirdViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var label: UILabel = {
        let label = UILabel()
        
        label.text = "Настройки пользователя"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupNavigationTools()
        setupConstraint()
        
        view.backgroundColor = .systemBlue
    }
    
    // MARK: - UI
    
    func setupElements() {
        view.addSubview(label)
    }
    
    private func setupNavigationTools() {
        self.title = "Настройки"
//        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward.circle.fill"), style: .plain, target: self, action: #selector(testFunc))
//        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addNewCountry))
//        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
//        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
    }
}
