//
//  PointViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit

class PointViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var pointTable: PointTableView = {
        let table = PointTableView()
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
        view.addSubview(pointTable)
    }
    
    private func setupNavigationTools() {
        self.title = "Информация о местах"
//        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward.circle.fill"), style: .plain, target: self, action: #selector(tappedBackButton))
//        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            pointTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            pointTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            pointTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            pointTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

}

extension PointViewController: PointTableViewDelegate {
    func selectRow(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
