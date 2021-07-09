//
//  PlacesTableView.swift
//  TravelMap
//
//  Created by Даниил Петров on 06.07.2021.
//

//import Foundation
import UIKit

protocol PlacesTableViewDelegate: AnyObject {
    func selectRow(viewController: UIViewController)
}

class PlacesTableView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: PlacesTableViewDelegate?
    
    lazy var placesTable: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.indentifirer)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
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
        addSubview(placesTable)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            placesTable.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            placesTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            placesTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            placesTable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Methods
    
}

// MARK: - UITableViewDataSource

extension PlacesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.indentifirer, for: indexPath)
        // передать значения
        (cell as? PlaceCell)?.configure()
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PlacesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pointViewController = PlacemarkViewController(placeLabelText: "тест \(indexPath.row)")
//        navigationController?.pushViewController(viewController, animated: true)
        delegate?.selectRow(viewController: pointViewController)
    }
}
