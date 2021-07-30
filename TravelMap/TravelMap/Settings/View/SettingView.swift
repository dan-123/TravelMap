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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var photoCountTextField: UITextField = {
       let textField = UITextField()
        return textField
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
    
    func getPlacesCountLabel(tableWidth: CGFloat, viewWidth: CGFloat, heigth: CGFloat, value: Int) -> UILabel {
        let labelFrame: CGRect = .init(x: tableWidth-viewWidth, y: 0, width: viewWidth, height: heigth)
        let placesCountLabel = UILabel(frame: labelFrame)
        placesCountLabel.text = String(value)
        placesCountLabel.textAlignment = .center
        return placesCountLabel
    }
    
    func getPhotoCountTextField(tableWidth: CGFloat, viewWidth: CGFloat, heigth: CGFloat, value: String) -> UITextField {
        let textFieldFrame: CGRect = .init(x: tableWidth-viewWidth, y: 0, width: viewWidth, height: heigth)
        photoCountTextField.frame = textFieldFrame
        photoCountTextField.layer.borderWidth = 1
        photoCountTextField.layer.cornerRadius = 8
        photoCountTextField.layer.borderColor = UIColor.systemBlue.cgColor
        photoCountTextField.textAlignment = .center
        photoCountTextField.keyboardType = .numberPad
        photoCountTextField.backgroundColor = .systemBackground
        return photoCountTextField
    }
    
    func reloadData() {
        settingTableView.reloadData()
    }
    
    func update(dataProvider: UITableViewDataSource & UITableViewDelegate & UITextFieldDelegate) {
        settingTableView.dataSource = dataProvider
        settingTableView.delegate = dataProvider
        photoCountTextField.delegate = dataProvider
    }
}
