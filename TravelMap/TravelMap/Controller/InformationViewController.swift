//
//  InformationViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 23.07.2021.
//

import Foundation
import UIKit

// MARK: - Properties

class InformationViewController: UIViewController {
    
    lazy var informationView: InformationView = {
        let informationView = InformationView()
        informationView.translatesAutoresizingMaskIntoConstraints = false
        return informationView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.scrollsToTop = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .green
        return scrollView
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
//        view.addSubview(informationView)
        view.addSubview(scrollView)
        scrollView.addSubview(informationView)
    }
    
    func setupConstraint() {
//        NSLayoutConstraint.activate([
//            informationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            informationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
//            informationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
//            informationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8)
//        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            informationView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 15),
            informationView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            informationView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15),
            informationView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15)
        ])
        
    }
}
