//
//  PlacesView.swift
//  TravelMap
//
//  Created by Даниил Петров on 06.07.2021.
//

import UIKit

final class PlacesView: UIView {
    
    // MARK: - Properties
    
    lazy var placesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        placesTableView.reloadData()
        setupElement()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupElement() {
        addSubview(placesTableView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            placesTableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            placesTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            placesTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            placesTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Methods
    
    func reloadData() {
        placesTableView.reloadData()
    }
    
    func update(dataProvider: UITableViewDataSource & UITableViewDelegate) {
        placesTableView.dataSource = dataProvider
        placesTableView.delegate = dataProvider
    }
}
