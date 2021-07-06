//
//  PointViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit

class PointViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var label: UILabel = {
        let label = UILabel()
        
        label.text = "Информация о местах"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupConstraint()
        
        view.backgroundColor = .systemBlue
    }
    
    // MARK: - UI
    
    func setupElements() {
        view.addSubview(label)
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
