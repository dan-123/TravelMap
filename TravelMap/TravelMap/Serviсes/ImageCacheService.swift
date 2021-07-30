//
//  ImageCache.swift
//  TravelMap
//
//  Created by Даниил Петров on 27.07.2021.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol ImageCacheProtocol {
    func saveImage(image: UIImage, key: String)
    func getImage(key: String) -> UIImage?
}

// MARK: - Image cache service

final class ImageCacheService {
    
    // MARK: Properties
    static let shared = ImageCacheService()
    let imageCache = NSCache<NSString, UIImage>()

    // MARK: Init
    private init() { }
}

// MARK: - Extensions ()

extension ImageCacheService: ImageCacheProtocol {
    func saveImage(image: UIImage, key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
}
