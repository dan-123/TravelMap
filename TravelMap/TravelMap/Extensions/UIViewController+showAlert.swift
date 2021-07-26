//
//  UIViewController+showAlert.swift
//  TravelMap
//
//  Created by Даниил Петров on 26.07.2021.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(for error: NetworkServiceError) {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: message(for: error),
                                      preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(buttonOk)
        present(alert, animated: true)
    }
    
    private func message(for error: NetworkServiceError) -> String {
        switch error {
        case .country:
            return "Кажется вы ввели некоректное название страны"
        case .city:
            return "Кажется вы ввели некоректное название города"
        case .repeatCountry:
            return "Вы уже добаляли эту страну ранее"
        case .repeatCity:
            return "Вы уже добаляли этот город ранее"
        case .network:
            return "Запрос сформирован некоорректно"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}
