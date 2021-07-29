//
//  UITableViewCell+Identifier.swift
//  TravelMap
//
//  Created by Даниил Петров on 30.07.2021.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
