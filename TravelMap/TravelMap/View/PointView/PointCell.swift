//
//  PointCell.swift
//  TravelMap
//
//  Created by Даниил Петров on 06.07.2021.
//

import Foundation
import UIKit

final class PointCell: UITableViewCell {

    static let indentifirer = "PointCell"

    // добавить аргументы
    func configure() {
        textLabel?.numberOfLines = 0
        textLabel?.text = "тест"
    }
    
}
