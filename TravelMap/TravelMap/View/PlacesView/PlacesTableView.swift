//
//  PlacesTableView.swift
//  TravelMap
//
//  Created by Даниил Петров on 06.07.2021.
//

import UIKit

protocol PlacesTableViewDelegate: AnyObject {
    //data source
    func getNumberOfSection(_ section: Int) -> Int
    func getData(at indexPath: IndexPath) -> Country
    //delegate
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        placesTable.reloadData()
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
    
    func reloadData() {
        placesTable.reloadData()
    }
}

// MARK: - Extensions (UITableViewDataSource)

extension PlacesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = delegate?.getNumberOfSection(section) else { return 0 }
        return section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let country = delegate?.getData(at: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") else { return UITableViewCell() }
        cell.textLabel?.text = country.country
        return cell
    }
}

// MARK: - Extensions (UITableViewDelegate)

extension PlacesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let country = delegate?.getData(at: indexPath) else { return }
        let pointViewController = CountryViewController(countryCode: country.countryCode, country: country.country)
        delegate?.selectRow(viewController: pointViewController)
    }
}
