//
//  AnnotationData.swift
//  TravelMap
//
//  Created by Даниил Петров on 08.07.2021.
//

// MARK: - Временное хранилище глобальных аннотаций

struct AnnotationData {
    var globalAnnotation = [String: [Double]]()
    var localAnnotation = [String: [CustomAnnotation]]()
}
