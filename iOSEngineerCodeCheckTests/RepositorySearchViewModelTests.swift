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

    override func setUp() {
        githubClient = GitHubClientProtocolMock()
        viewModel = RepositorySearchViewModel(githubClient: githubClient)
    }

    func testSearchSuccess() async throws {
        githubClient.searchHandler = { _ in
            return [
                .mock(fullName: "apple/swift"),
                .mock(fullName: "openstack/swift"),
                .mock(fullName: "tensorflow/swift"),
                .mock(fullName: "SwiftyJSON/SwiftyJSON"),
                .mock(fullName: "ipader/SwiftGuide"),
            ]
        }

        try await asyncTest(
            operation: {
                self.viewModel.onSearchButtonTapped(query: "swift")
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await nextValues(of: viewModel.events, count: 2),
                    [.unfocusFromSearchBar, .reloadData]
                )

                XCTAssertEqual(viewModel.repositoriesCount(), 5)
                XCTAssertEqual(viewModel.repository(index: 0)?.fullName, "apple/swift")

                try await XCTAssertAwaitTrue(
                    try await noNextValue(of: viewModel.events)
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
                    try await nextValues(of: viewModel.events, count: 1),
                    [.unfocusFromSearchBar]
                )

                try await XCTAssertAwaitTrue(
                    try await noNextValue(of: viewModel.events)
                )
            }
        )
    }
}
