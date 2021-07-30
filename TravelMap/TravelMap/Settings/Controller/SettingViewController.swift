//
//  SettingViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    //переделать
    let userDefaultServices = UserDefaultsService()
    
    lazy var settingView: SettingView = {
        let settingView = SettingView()
        settingView.translatesAutoresizingMaskIntoConstraints = false
        return settingView
    }()
    
    private var countryCount: Int = 0
    private var citiesCount: Int = 0
    private var photoCount: String = ""
    
    private var model = SettingModel.allCases
    
    private var onDidResigneResponder: (() -> Void)?
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(hideKeybord))
    }()
    
    // MARK: - Dependencies
    
    private let coreDataService: CoreDataServiceCityProtocol & CoreDataServiceCountryProtocol
    
    // MARK: - Init
    
    init(coreDataService: CoreDataServiceCityProtocol & CoreDataServiceCountryProtocol) {
        self.coreDataService = coreDataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupNavigationTools()
        setupConstraint()
        settingView.update(dataProvider: self)
        setupGesture()
        setupPhotoCount()
        
        view.backgroundColor = .systemBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    // MARK: - UI
    
    func setupElements() {
        view.addSubview(settingView)
    }
    
    private func setupNavigationTools() {
        self.title = Constants.ControllerTitle.settingTitle
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Action
    
    @objc func hideKeybord() {
        //        settingView.photoCountTextField.resignFirstResponder()
        onDidResigneResponder?()
        tapGesture.isEnabled = false
    }
    
    // MARK: - Methods
    
    private func setupPhotoCount() {
        if let data: String = userDefaultServices.getData(key: Constants.UserDefaultsKey.keyForPhotoCount) {
            //            settingView.photoCountTextField.text = data
            photoCount = data
        } else {
            photoCount = String(Constants.Settings.defaultCountOfPhoto)
            //            settingView.photoCountTextField.text = photoCount
            userDefaultServices.saveData(object: photoCount, key: Constants.UserDefaultsKey.keyForPhotoCount)
        }
    }
    
    private func getData() {
        countryCount = coreDataService.getCountryData(predicate: nil)?.count ?? 0
        citiesCount = coreDataService.getCityData(predicate: nil)?.count ?? 0
        settingView.reloadData()
    }
    
    private func deleteData() {
        coreDataService.deleteCountry(country: nil)
        coreDataService.deleteCity(city: nil)
        getData()
    }
    
    private func setupGesture() {
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Extensions (UITableViewDataSource)

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if model[indexPath.row] == .photosDisplayedCount {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewInputCell.reusableIdentifier, for: indexPath) as? TableViewInputCell else { return UITableViewCell() }
            cell.update(title: model[indexPath.row].description, photoCount: photoCount, delegate: self)
            onDidResigneResponder = {
                cell.resignTextFieldResponder()
            }
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: UITableViewCell.reusableIdentifier)
            cell.textLabel?.text = model[indexPath.row].description
            
            switch model[indexPath.row] {
            case .countryCount, .citiesCount:
                cell.selectionStyle = .none
            case .deleteData, .aboutApplication:
                cell.selectionStyle = .default
            default:
                break
            }
            
            if model[indexPath.row] == .aboutApplication {
                cell.accessoryType = .disclosureIndicator
            }
            
            var cellDescription: String?
            switch model[indexPath.row] {
            case .countryCount:
                cellDescription = String(countryCount)
            case .citiesCount:
                cellDescription = String(citiesCount)
            default:
                break
            }
            cell.detailTextLabel?.text = cellDescription
            return cell
        }
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = UITableViewCell()
    //        cell.selectionStyle = .none
    //
    //        let tableWidth = tableView.frame.width
    //        let viewWidth: CGFloat = 45
    //        let heigth = cell.frame.height
    //
    //        switch model[indexPath.row] {
    //        case .countryCount:
    //            cell.textLabel?.text = model[indexPath.row].description
    //            let label = settingView.getPlacesCountLabel(tableWidth: tableWidth, viewWidth: viewWidth, heigth: heigth, value: countryCount)
    //            cell.addSubview(label)
    //
    //        case .citiesCount:
    //            cell.textLabel?.text = model[indexPath.row].description
    //            let label = settingView.getPlacesCountLabel(tableWidth: tableWidth, viewWidth: viewWidth, heigth: heigth, value: citiesCount)
    //            cell.addSubview(label)
    //
    //        case .photosDisplayedCount:
    //            cell.textLabel?.text = model[indexPath.row].description
    //            let textField = settingView.getPhotoCountTextField(tableWidth: tableWidth, viewWidth: viewWidth, heigth: heigth, value: photoCount)
    //            cell.addSubview(textField)
    //
    //        case .deleteData:
    //            cell.textLabel?.text = model[indexPath.row].description
    //            cell.selectionStyle = .default
    //
    //        case .aboutApplication:
    //            cell.textLabel?.text = model[indexPath.row].description
    //            cell.accessoryType = .disclosureIndicator
    //            cell.selectionStyle = .default
    //        }
    //        return cell
    //    }
}

// MARK: - Extensions (UITableViewDelegate)

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        switch model[indexPath.row] {
        case .countryCount, .citiesCount, .photosDisplayedCount: break
        case .deleteData:
            
            if (countryCount == 0 && citiesCount == 0) {
                showAlertController(haveData: false, title: "Удаление данных", message: "Пока не добавлено ни одной страны и города")
            } else {
                showAlertController(haveData: true, title: "Удаление данных", message: "Вы уверены что хотите удалить данные?")
            }
        case .aboutApplication:
            navigationController?.pushViewController(InformationViewController(), animated: true)
        }
        
    }
    
    private func showAlertController(haveData: Bool, title: String, message: String) {
        let alertConrtoller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if haveData {
            let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
                self.deleteData()
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertConrtoller.addAction(okAction)
            alertConrtoller.addAction(cancelAction)
        } else {
            let okAction = UIAlertAction(title: "ОК", style: .default)
            alertConrtoller.addAction(okAction)
        }
        
        present(alertConrtoller, animated: true)
    }
}

// MARK: - Extensions (UITextFieldDelegate)

extension SettingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tapGesture.isEnabled = true
        guard let text = textField.text else { return true }
        photoCount = text
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              let value = Int(text) else {
            textField.text = photoCount
            return
        }
        
        if Constants.Settings.defaultCountOfPhoto ... Constants.Settings.maxiNumberOfPhotos ~= value {
            userDefaultServices.saveData(object: text, key: Constants.UserDefaultsKey.keyForPhotoCount)
            textField.text = text
            photoCount = text
        } else {
            let alertConrtoller = UIAlertController(title: "Предупреждение", message: "Количество фото должно быть в  диапазоне от 3 до 20", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
                guard let self = self else { return }
                textField.text = self.photoCount
            }
            alertConrtoller.addAction(okAction)
            present(alertConrtoller, animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        return (textField.text?.count ?? 0 ) + string.count <= 2
    }
}
