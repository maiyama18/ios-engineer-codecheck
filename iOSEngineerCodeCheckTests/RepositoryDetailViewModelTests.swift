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

@MainActor
class RepositoryDetailViewModelTests: XCTestCase {
    private var viewModel: RepositoryDetailViewModel!

    private let mockRepository = Repository(
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

    func testProperties() async throws {
        viewModel = RepositoryDetailViewModel(repository: mockRepository)

        XCTAssertEqual(viewModel.organization, "apple")
        XCTAssertEqual(viewModel.repositoryName, "swift")
        XCTAssertEqual(viewModel.language, Language(name: "C++", colorCode: "6866fb"))
        XCTAssertEqual(viewModel.avatarURL, URL(string: "http://example.com/avatars/1"))
        XCTAssertEqual(viewModel.starsCount, "50000")
        XCTAssertEqual(viewModel.watchesCount, "10000")
        XCTAssertEqual(viewModel.forksCount, "2000")
        XCTAssertEqual(viewModel.issuesCount, "200")
    }

    func testOpenURLTapped() async throws {
        viewModel = RepositoryDetailViewModel(repository: mockRepository)

        try await asyncTest(
            operation: { self.viewModel.onOpenURLTapped() },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream),
                    .openURL(url: URL(string: "https://github.com/apple/swift")!)
                )

                try await XCTAssertAwaitTrue(try await noValue(of: viewModel.eventStream))
            }
        )
    }

    func testShareURLTapped() async throws {
        viewModel = RepositoryDetailViewModel(repository: mockRepository)

        try await asyncTest(
            operation: { self.viewModel.onShareURLTapped() },
            assertions: {
                try await XCTAssertAwaitEqual(
                    try await awaitValue(of: viewModel.eventStream),
                    .shareURL(url: URL(string: "https://github.com/apple/swift")!)
                )

                try await XCTAssertAwaitTrue(try await noValue(of: viewModel.eventStream))
            }
        )
    }
}
