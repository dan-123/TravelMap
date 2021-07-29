//
//  TravelMapSnapshotTests.swift
//  TravelMapSnapshotTests
//
//  Created by Даниил Петров on 29.07.2021.
//

import SnapshotTesting
import XCTest
@testable import TravelMap

class SnapshotTest: XCTestCase {

    func testInformationViewController() throws {
        let informationViewController = InformationViewController()
        assertSnapshot(matching: informationViewController, as: .image(on: .iPhoneXr))
    }
}
