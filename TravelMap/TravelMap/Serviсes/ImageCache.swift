//
//  ImageCache.swift
//  TravelMap
//
//  Created by Даниил Петров on 27.07.2021.
//

import Foundation
import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    
    let imageCache = NSCache<NSString, UIImage>()

    private init() { }
}
