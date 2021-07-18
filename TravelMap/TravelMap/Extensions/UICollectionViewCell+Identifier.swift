//
//  UICollectionViewCell+Identifier.swift
//  TravelMap
//
//  Created by Даниил Петров on 18.07.2021.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
