//
//  TableViewInputCell.swift
//  TravelMap
//
//  Created by Даниил Петров on 30.07.2021.
//

import UIKit

class TableViewInputCell: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var photoCountTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.backgroundColor = .systemBackground
        return textField
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupElement()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupElement() {
        contentView.addSubview(photoCountTextField)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            photoCountTextField.widthAnchor.constraint(equalToConstant: 40),
            photoCountTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            photoCountTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            photoCountTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    // MARK: - Methods
    
    func resignTextField() {
        photoCountTextField.resignFirstResponder()
    }
    
    func update(title: String, photoCount: String, delegate: UITextFieldDelegate) {
        textLabel?.text = title
        photoCountTextField.text = photoCount
        photoCountTextField.delegate = delegate
    }
}
