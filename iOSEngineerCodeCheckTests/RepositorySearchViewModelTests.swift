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

@MainActor
class RepositorySearchViewModelTests: XCTestCase {
    private var viewModel: RepositorySearchViewModel!
    private var githubClient: GitHubClientProtocolMock!

    private let mockRepositories: [Repository] = [
        .mock(fullName: "apple/swift", starsCount: 10000),
        .mock(
            fullName: "openstack/swift", starsCount: 1000,
            language: Language(name: "Swift", colorCode: "223344")),
        .mock(fullName: "tensorflow/swift", starsCount: 20000),
        .mock(
            fullName: "SwiftyJSON/SwiftyJSON", starsCount: 500,
            language: Language(name: "Swift", colorCode: "223344")),
        .mock(
            fullName: "ipader/SwiftGuide", starsCount: 5000,
            language: Language(name: "Swift", colorCode: "223344")),
    ]

    @MainActor
    override func setUp() {
        githubClient = GitHubClientProtocolMock()
        viewModel = RepositorySearchViewModel(githubClient: githubClient)
    }

    func testSearchSuccess() async throws {
        githubClient.searchHandler = { query, _, _ in
            guard query == "swift" else {
                XCTFail("unexpected query")
                return []
            }
            return self.mockRepositories
        }

        viewModel.query = "swift"

        try await asyncTest(
            operation: {
                self.viewModel.onSearchButtonTapped()
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .showLoading)

                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .hideLoading)

                try await XCTAssertAwaitEqual(viewModel.repositories, mockRepositories)

                try await XCTAssertAwaitTrue(try await noValue(of: viewModel.eventStream))
            }
        )
    }

    func testSearchFailure() async throws {
        githubClient.searchHandler = { _, _, _ in
            throw GitHubError.unexpectedError
        }

        viewModel.query = "swift"

        try await asyncTest(
            operation: {
                self.viewModel.onSearchButtonTapped()
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .showLoading)

                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream),
                    .showErrorAlert(message: L10n.Error.unexpectedError)
                )

                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .hideLoading)

                try await XCTAssertAwaitEqual(viewModel.repositories, [])

                try await XCTAssertAwaitTrue(
                    try await noValue(of: viewModel.eventStream)
                )
            }
        )
    }

    func testSortOrderChange() async throws {
        githubClient.searchHandler = { query, sortOrder, _ in
            guard query == "swift" else {
                XCTFail("unexpected query")
                return []
            }
            if sortOrder == .stars {
                return self.mockRepositories.sorted(by: { $0.starsCount > $1.starsCount })
            } else {
                return self.mockRepositories
            }
        }

        viewModel.query = "swift"

        try await asyncTest(
            operation: {
                self.viewModel.onSearchButtonTapped()
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .showLoading)

                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .hideLoading)

                try await XCTAssertAwaitEqual(viewModel.repositories, mockRepositories)
            }
        )

        try await asyncTest(
            operation: {
                self.viewModel.sortOrder = .stars
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .showLoading)

                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .hideLoading)

                try await XCTAssertAwaitEqual(
                    viewModel.repositories,
                    mockRepositories.sorted(by: { $0.starsCount > $1.starsCount })
                )

                try await XCTAssertAwaitTrue(try await noValue(of: viewModel.eventStream))
            }
        )
    }

    func testSortOrderChangeAfterQueryChange() async throws {
        githubClient.searchHandler = { query, sortOrder, _ in
            guard query == "swift" else {
                XCTFail("unexpected query")
                return []
            }
            if sortOrder == .stars {
                return self.mockRepositories.sorted(by: { $0.starsCount > $1.starsCount })
            } else {
                return self.mockRepositories
            }
        }

        viewModel.query = "swift"

        try await asyncTest(
            operation: {
                self.viewModel.onSearchButtonTapped()
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .showLoading)

                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .hideLoading)

                try await XCTAssertAwaitEqual(viewModel.repositories, mockRepositories)
            }
        )

        try await asyncTest(
            operation: {
                Task {
                    self.viewModel.query = "updated"
                    self.viewModel.sortOrder = .stars
                }
            },
            assertions: {
                try await XCTAssertAwaitTrue(try await noValue(of: viewModel.eventStream))
            }
        )
    }

    func testLanguageChange() async throws {
        githubClient.searchHandler = { query, _, language in
            guard query == "swift" else {
                XCTFail("unexpected query")
                return []
            }
            if let language = language {
                if language == "Swift" {
                    return self.mockRepositories.filter { $0.language?.name == "Swift" }
                } else {
                    XCTFail("unexpected language: \(language)")
                    return []
                }
            } else {
                return self.mockRepositories
            }
        }

        viewModel.query = "swift"

        try await asyncTest(
            operation: {
                self.viewModel.onSearchButtonTapped()
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .showLoading)

                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .hideLoading)

                try await XCTAssertAwaitEqual(viewModel.repositories, mockRepositories)
            }
        )

        try await asyncTest(
            operation: {
                self.viewModel.language = "Swift"
            },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .showLoading)

                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream), .hideLoading)

                try await XCTAssertAwaitEqual(
                    viewModel.repositories,
                    mockRepositories.filter { $0.language?.name == "Swift" }
                )

                try await XCTAssertAwaitTrue(try await noValue(of: viewModel.eventStream))
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
                    try await awaitValue(of: viewModel.eventStream),
                    .navigateToDetail(repository: .mock(fullName: "apple/swift"))
                )

                try await XCTAssertAwaitTrue(try await noValue(of: viewModel.eventStream))
            }
        )
    }
}
