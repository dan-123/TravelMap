//
//  SettingView.swift
//  TravelMap
//
//  Created by Даниил Петров on 18.07.2021.
//

import Foundation
import UIKit

final class SettingView: UIView {
    
    // MARK: - Properties
    
    let cellIdentifier = "DefaultCell"
    
    private lazy var settingTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reusableIdentifier)
        tableView.register(TableViewInputCell.self, forCellReuseIdentifier: TableViewInputCell.reusableIdentifier)
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 44
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
        addSubview(settingTableView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            settingTableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            settingTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            settingTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            settingTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Methods
    
    func reloadData() {
        settingTableView.reloadData()
    }
    
    func update(dataProvider: UITableViewDataSource & UITableViewDelegate) {
        settingTableView.dataSource = dataProvider
        settingTableView.delegate = dataProvider
    }
}
