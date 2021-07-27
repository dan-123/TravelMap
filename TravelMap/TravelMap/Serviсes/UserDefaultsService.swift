//
//  UserDefaultsService.swift
//  TravelMap
//
//  Created by Даниил Петров on 26.07.2021.
//

import Foundation

// MARK: - Protocol

protocol UserDefaultsServiceProtocol {
    func saveData<T: Encodable>(object: T, key: String)
    func getData<T: Decodable>(key: String) -> T?
}

// MARK: - User defaults service

class UserDefaultsService {
    
    // MARK: Properties
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: Init
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    convenience init() {
        self.init(userDefaults: UserDefaults.standard)
    }
}

// MARK: - Extension (UserDefaultsServiceProtocol)

extension UserDefaultsService: UserDefaultsServiceProtocol {
    func saveData<T: Encodable>(object: T, key: String) {
        guard let data = try? encoder.encode(object) else { return }
        userDefaults.setValue(data, forKey: key)
    }
    
    func getData<T: Decodable>(key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
}
