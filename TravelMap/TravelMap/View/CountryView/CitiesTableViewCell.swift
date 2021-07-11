//
//  CitiesTableViewCell.swift
//  TravelMap
//
//  Created by Даниил Петров on 11.07.2021.
//

import UIKit

final class CitiesTableViewCell: UITableViewCell {

//    static let indentifirer = "CitiesTableViewCell"

    // добавить аргументы
    func configure() {
        textLabel?.numberOfLines = 0
        textLabel?.text = "город"
    }
    
}
