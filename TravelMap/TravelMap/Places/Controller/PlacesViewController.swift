//
//  PlacesViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit

final class PlacesViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var placesTableView: PlacesView = {
        let tableView = PlacesView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Dependencies
    
    private let coordinateLoaderService: CoordinateCountryLoaderServiceProtocol
    private let coreDataService: CoreDataService
    
    // MARK: - Init
    
    init(coordinateLoaderService: CoordinateCountryLoaderServiceProtocol,
         coreDataService: CoreDataService) {
        self.coordinateLoaderService = coordinateLoaderService
        self.coreDataService = coreDataService
        super.init(nibName: nil, bundle: nil)
        self.coreDataService.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCountry))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            placesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Action
    
    @objc private func addCountry() {
        let alertConrtoller = UIAlertController(title: "Новая страна", message: "Добавление новой страны", preferredStyle: .alert)
        alertConrtoller.addTextField()
        
        let okAction = UIAlertAction(title: "ОК", style: .default) { [weak alertConrtoller] _ in
            let textField = alertConrtoller?.textFields?.first
            guard let country = textField?.text else { return }
            self.loadCountry(country: country)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertConrtoller.addAction(okAction)
        alertConrtoller.addAction(cancelAction)
        present(alertConrtoller, animated: true)
    }
    
    // MARK: - Methods
    
    private func loadCountry(country: String) {
        coordinateLoaderService.loadCountryCoordinate(country: country) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                print("added new country in table")
            case .failure(let error):
                self.showAlert(for: error)
            }
        }
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

// MARK: - Extensions (CoreDataSeriviceDelegate)
extension PlacesViewController: CoreDataSeriviceDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.placesTableView.reloadData()
        }
    }
}
