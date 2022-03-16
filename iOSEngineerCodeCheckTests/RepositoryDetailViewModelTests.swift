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
    private var session: NetworkingMock!

    private let mockImageData = UIImage(systemName: "applelogo")!.pngData()!

    override func setUp() {
        session = NetworkingMock()
    }

    func testImageLoadSuccess() async throws {
        session.dataHandler = { request, _ in
            (
                self.mockImageData,
                HTTPURLResponse(
                    url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            )
        }

        viewModel = RepositoryDetailViewModel(
            repository: Repository(
                fullName: "apple/swift",
                description: "Swift compiler",
                language: Language(name: "C++", colorCode: "6866fb"),
                avatarURL: URL(string: "http://example.com"),
                starsCount: 50000,
                watchersCount: 10000,
                forksCount: 2000,
                openIssuesCount: 200
            ),
            session: session
        )

        XCTAssertEqual(viewModel.titleText, "apple/swift")
        XCTAssertEqual(viewModel.languageText, "Written in C++")
        XCTAssertEqual(viewModel.starsText, "50000 stars")
        XCTAssertEqual(viewModel.watchersText, "10000 watchers")
        XCTAssertEqual(viewModel.forksText, "2000 forks")
        XCTAssertEqual(viewModel.openIssuesText, "200 open issues")

        try await asyncTest(
            operation: {
                self.viewModel.onViewLoaded()
            },
            assertions: {
                let events = try await nextValues(of: viewModel.events, count: 1)
                guard case .avatarImageLoaded(let image) = events[0] else {
                    XCTFail("event not expected type")
                    return
                }
                XCTAssertEqual(
                    image.pngData()!,
                    UIImage(data: mockImageData)?.pngData()!
                )

                try await XCTAssertAwaitTrue(
                    try await noNextValue(of: viewModel.events)
                )
            }
        )
    }

    func testImageLoadFailure() async throws {
        session.dataHandler = { request, _ in
            (
                "error".data(using: .utf8)!,
                HTTPURLResponse(
                    url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            )
        }

        viewModel = RepositoryDetailViewModel(
            repository: .mock(fullName: "apple/swift"),
            session: session
        )

        try await asyncTest(
            operation: {
                self.viewModel.onViewLoaded()
            },
            assertions: {
                try await XCTAssertAwaitTrue(
                    try await noNextValue(of: viewModel.events)
                )
            }
        )
    }
}
