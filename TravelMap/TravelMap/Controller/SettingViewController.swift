//
//  SettingViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var settingView: SettingView = {
        let label = SettingView()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupNavigationTools()
        setupConstraint()
        settingView.update(dataProvider: self)
        
        view.backgroundColor = .systemBlue
    }
    
    // MARK: - UI
    
    func setupElements() {
        view.addSubview(settingView)
    }
    
    private func setupNavigationTools() {
        self.title = Constants.ControllerTitle.settingTitle
//        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward.circle.fill"), style: .plain, target: self, action: #selector(testFunc))
//        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addNewCountry))
//        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
//        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            settingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            settingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            settingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}


// MARK: - Extensions (UITableViewDataSource)

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: settingView.cellIdentifier) else { return UITableViewCell() }
        cell.textLabel?.text = "информация"
//        cell.
        return cell
    }
}

// MARK: - Extensions (UITableViewDelegate)

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        guard let country = delegate?.getData(at: indexPath) else { return }
//        let pointViewController = CountryViewController(countryCode: country.countryCode, country: country.country)
//        delegate?.selectRow(viewController: pointViewController)
    }
}
