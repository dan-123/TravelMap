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
    lazy var coreDataService: CoreDataService = {
        let coreDataService = CoreDataService()
        coreDataService.delegate = self
        return coreDataService
    }()
    
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
        self.title = Constants.ControllerTitle.placesTitle
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
        cell.accessoryType = .disclosureIndicator
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let country = coreDataService.frcCountry.object(at: indexPath)
        if let cities = coreDataService.getCityData(predicate: country.countryCode) {
            coreDataService.deleteCity(city: cities)
        }
        
        let countryDTO = CountryDTO(countryCode: country.countryCode, country: country.country, latitude: country.latitude, longitude: country.longitude, border: country.border)

        coreDataService.deleteCountry(country: [countryDTO])
        
    }
}

#warning("reload data")
extension PlacesViewController: CoreDataSeriviceDelegate {
    func reloadData() {
        placesTableView.reloadData()
    }
}
