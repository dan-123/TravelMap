//
//  InformationViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 23.07.2021.
//

import Foundation
import UIKit

// MARK: - Properties

final class InformationViewController: UIViewController {
    
    lazy var informationView: InformationView = {
        let informationView = InformationView()
        informationView.translatesAutoresizingMaskIntoConstraints = false
        return informationView
    }()
    
    private let informationModel = InformationModel()
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupConstraint()
        informationView.setupText(text: informationModel.information)
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - UI
    
    func setupElements() {
        view.addSubview(informationView)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            informationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            informationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            informationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            informationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
