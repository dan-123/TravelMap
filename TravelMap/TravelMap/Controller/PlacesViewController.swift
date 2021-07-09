//
//  PlacesViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit

class PlacesViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var placesTable: PlacesTableView = {
        let table = PlacesTableView()
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        
        view.backgroundColor = .systemBlue
    }
    
    // MARK: - UI
    
    func setupElements() {
        view.addSubview(placesTable)
    }
    
    private func setupNavigationTools() {
        self.title = "Места"
//        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward.circle.fill"), style: .plain, target: self, action: #selector(tappedBackButton))
//        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            placesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            placesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            placesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            placesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

}

extension PlacesViewController: PlacesTableViewDelegate {
    func selectRow(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
