//
//  PlacesViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit

class PlacesViewController: UIViewController {
    
    // MARK: - Properties
    
    //переделать
    let coreDataService = CoreDataService()
    
    lazy var placesTableView: PlacesView = {
        let tableView = PlacesView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        placesTableView.update(dataProvider: self)
        
        view.backgroundColor = .systemBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        try? coreDataService.frcCountry.performFetch()
        placesTableView.reloadData()
    }
    
    // MARK: - UI
    
    func setupElements() {
        view.addSubview(placesTableView)
    }
    
    private func setupNavigationTools() {
        self.title = "Места"
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            placesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            placesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            placesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            placesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: - Extensions (UITableViewDataSource)

extension PlacesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = coreDataService.frcCountry.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") else { return UITableViewCell() }
        let country = coreDataService.frcCountry.object(at: indexPath)
        cell.textLabel?.text = country.country
        return cell
    }
}

// MARK: - Extensions (UITableViewDelegate)

extension PlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let country = coreDataService.frcCountry.object(at: indexPath)
        let countryViewController = CountryViewController(countryCode: country.countryCode, country: country.country)
        navigationController?.pushViewController(countryViewController, animated: true)
    }
}
