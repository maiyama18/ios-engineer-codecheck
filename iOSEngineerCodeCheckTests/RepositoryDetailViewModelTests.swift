//
//  RepositoryDetailViewModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by maiyama on 2022/03/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import GitHub
import XCTest

@testable import iOSEngineerCodeCheck

class RepositoryDetailViewModelTests: XCTestCase {
    private var viewModel: RepositoryDetailViewModel!

    func testProperties() async throws {
        viewModel = RepositoryDetailViewModel(
            repository: Repository(
                fullName: "apple/swift",
                description: "Swift compiler",
                language: Language(name: "C++", colorCode: "6866fb"),
                avatarURL: URL(string: "http://example.com/avatars/1"),
                starsCount: 50000,
                watchersCount: 10000,
                forksCount: 2000,
                openIssuesCount: 200,
                repositoryURL: URL(string: "https://github.com/apple/swift")
            )
        )

        XCTAssertEqual(viewModel.organization, "apple")
        XCTAssertEqual(viewModel.repositoryName, "swift")
        XCTAssertEqual(viewModel.language, Language(name: "C++", colorCode: "6866fb"))
        XCTAssertEqual(viewModel.avatarURL, URL(string: "http://example.com/avatars/1"))
        XCTAssertEqual(viewModel.starsCount, "50000")
        XCTAssertEqual(viewModel.watchesCount, "10000")
        XCTAssertEqual(viewModel.forksCount, "2000")
        XCTAssertEqual(viewModel.issuesCount, "200")
    }

}
