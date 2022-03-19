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

        await MainActor.run {
            viewModel.query = "swift"
        }

        try await asyncTest(
            operation: {
                self.viewModel.onSearchButtonTapped()
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await nextValues(of: viewModel.events, count: 2),
                    [
                        .showLoading,
                        .hideLoading,
                    ]
                )

                try await XCTAssertAwaitEqual(
                    await viewModel.repositories,
                    mockRepositories
                )

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

        await MainActor.run {
            viewModel.query = "swift"
        }

        try await asyncTest(
            operation: {
                self.viewModel.onSearchButtonTapped()
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await nextValues(of: viewModel.events, count: 3),
                    [
                        .showLoading,
                        .showErrorAlert(message: L10n.Error.unexpectedError),
                        .hideLoading,
                    ]
                )

                try await XCTAssertAwaitEqual(
                    await viewModel.repositories,
                    []
                )

                try await XCTAssertAwaitTrue(
                    try await noNextValue(of: viewModel.events)
                )
            }
        )
    }

    func testRepositoryTap() async throws {
        try await asyncTest(
            operation: {
                self.viewModel.onRepositoryTapped(repository: .mock(fullName: "apple/swift"))
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await nextValues(of: viewModel.events, count: 1),
                    [.navigateToDetail(repository: .mock(fullName: "apple/swift"))]
                )

                try await XCTAssertAwaitTrue(
                    try await noNextValue(of: viewModel.events)
                )
            }
        )
    }
}
