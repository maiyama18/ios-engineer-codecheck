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

        let searchField = app.textFields["searchField"]
        searchField.tap()
        searchField.typeText("swift\n")

        XCTAssertTrue(app.staticTexts["listRepositoryTitle"].waitForExistence(timeout: 3))
        let titles = app.staticTexts.matching(identifier: "listRepositoryTitle")

        titles.element(boundBy: 0).tap()

        XCTAssertTrue(app.staticTexts["organizationText"].waitForExistence(timeout: 3))
    }
}
