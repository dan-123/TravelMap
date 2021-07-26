//
//  SettingModel.swift
//  TravelMap
//
//  Created by Даниил Петров on 18.07.2021.
//

import Foundation

enum SettingModel: CaseIterable {
    case countryCount
    case citiesCount
    case photosDisplayedCount
    case deleteData
    case aboutApplication
    
    var description: String? {
        switch self {
        case .countryCount:
            return "Количество стран"
        case .citiesCount:
            return "Количество городов"
        case .photosDisplayedCount:
            return "Количество отображаемых фото"
        case .deleteData:
            return "Удалить данные"
        case .aboutApplication:
            return "О приложении"
            
        }
    }
}
