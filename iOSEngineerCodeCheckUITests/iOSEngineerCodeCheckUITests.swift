//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class iOSEngineerCodeCheckUITests: XCTestCase {
    func testSearchAndNavigateToDetail() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.searchFields["Search..."]
        searchField.tap()
        searchField.typeText("swift\n")

        XCTAssertTrue(app.cells["SubtitleCell"].waitForExistence(timeout: 3))
        let cells = app.cells.matching(identifier: "SubtitleCell")
        XCTAssertEqual(cells.count, 30)

        cells.element(boundBy: 0).tap()

        XCTAssertTrue(app.staticTexts["DetailTitleLabel"].waitForExistence(timeout: 3))
    }
}
