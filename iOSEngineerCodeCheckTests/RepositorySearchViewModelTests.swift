//
//  RepositorySearchViewModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import GitHub
import XCTest

@testable import iOSEngineerCodeCheck

class RepositorySearchViewModelTests: XCTestCase {
    private var viewModel: RepositorySearchViewModel!
    private var githubClient: GitHubClientProtocolMock!

    private let mockRepositories: [Repository] = [
        .mock(fullName: "apple/swift"),
        .mock(fullName: "openstack/swift"),
        .mock(fullName: "tensorflow/swift"),
        .mock(fullName: "SwiftyJSON/SwiftyJSON"),
        .mock(fullName: "ipader/SwiftGuide"),
    ]

    override func setUp() {
        githubClient = GitHubClientProtocolMock()
        viewModel = RepositorySearchViewModel(githubClient: githubClient)
    }

    func testSearchSuccess() async throws {
        githubClient.searchHandler = { query in
            guard query == "swift" else {
                XCTFail("unexpected query")
                return []
            }
            return self.mockRepositories
        }

        try await asyncTest(
            operation: {
                self.viewModel.onSearchButtonTapped(query: "swift")
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await nextValues(of: viewModel.$repositories, count: 2),
                    [[], mockRepositories]
                )
            }
        )
    }

    func testSearchFailure() async throws {
        githubClient.searchHandler = { _ in
            throw GitHubError.unexpectedError
        }

        try await asyncTest(
            operation: {
                self.viewModel.onSearchButtonTapped(query: "swift")
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await nextValues(of: viewModel.$repositories, count: 1),
                    [[]]
                )
            }
        )
    }
}
