//
//  SettingView.swift
//  TravelMap
//
//  Created by Даниил Петров on 18.07.2021.
//

import Foundation
import UIKit

class SettingView: UIView {
    
    // MARK: - Properties
    
    private lazy var settingTable: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
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
        addSubview(settingTable)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            settingTable.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            settingTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            settingTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            settingTable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Methods
    
}

// MARK: - Extensions (UITableViewDataSource)

extension SettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") else { return UITableViewCell() }
        cell.textLabel?.text = "информация"
//        cell.
        return cell
    }
}

// MARK: - Extensions (UITableViewDelegate)

extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        guard let country = delegate?.getData(at: indexPath) else { return }
//        let pointViewController = CountryViewController(countryCode: country.countryCode, country: country.country)
//        delegate?.selectRow(viewController: pointViewController)
    }
}
