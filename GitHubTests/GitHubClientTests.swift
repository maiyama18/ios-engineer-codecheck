//
//  GitHubClientTests.swift
//  GitHubTests
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest

@testable import GitHub

class GitHubClientTests: XCTestCase {
    private var client: GitHubClient!
    private var session: NetworkingMock!
    private var userDefaults: UserDefaults!

    override func setUp() {
        session = NetworkingMock()

        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)

        client = GitHubClient(session: session, userDefaults: userDefaults)
    }

    func testSearchSuccess() async throws {
        try setUpMockSession(
            responseFileName: "search_success", statusCode: 200, rateLimitRemaining: 9)

        let repositories = try await client.search(query: "swift", sortOrder: .bestMatch, page: 1)
        XCTAssertEqual(repositories.count, 30)

        let first = repositories[0]
        XCTAssertEqual(first.fullName, "apple/swift")
        XCTAssertEqual(first.language, Language(name: "C++", colorCode: "f34b7d"))
        XCTAssertEqual(first.starsCount, 58955)
        XCTAssertEqual(first.watchersCount, 58955)
        XCTAssertEqual(first.forksCount, 9465)
        XCTAssertEqual(first.openIssuesCount, 505)
        XCTAssertEqual(
            first.avatarURL?.absoluteString, "https://avatars.githubusercontent.com/u/10639145?v=4")
        XCTAssertEqual(first.repositoryURL?.absoluteString, "https://github.com/apple/swift")

        XCTAssertEqual(client.getSearchHistory(maxCount: 100), ["swift"])
    }

    func testSearchFailureEmptySearchQuery() async throws {
        try setUpMockSession(
            responseFileName: "search_failure_empty_search_query", statusCode: 400,
            rateLimitRemaining: 9)

        do {
            let _ = try await client.search(query: "", sortOrder: .bestMatch, page: 1)
        } catch {
            XCTAssertEqual(error as? GitHubError, GitHubError.emptySearchQuery)
            XCTAssertEqual(client.getSearchHistory(maxCount: 100), [])
            return
        }
        XCTFail("expected an error to be thrown, but not.")
    }

    func testSearchFailureTooManyRequest() async throws {
        try setUpMockSession(
            responseFileName: "search_failure_too_many_request", statusCode: 403,
            rateLimitRemaining: 0)

        do {
            let _ = try await client.search(query: "swift", sortOrder: .bestMatch, page: 1)
        } catch {
            XCTAssertEqual(error as? GitHubError, GitHubError.tooManyRequests)
            XCTAssertEqual(client.getSearchHistory(maxCount: 100), [])
            return
        }
        XCTFail("expected an error to be thrown, but not.")
    }

    func testSearchFailureInternalServerError() async throws {
        try setUpMockSession(
            responseFileName: "search_failure_internal_server_error", statusCode: 500,
            rateLimitRemaining: 9)

        do {
            let _ = try await client.search(query: "swift", sortOrder: .bestMatch, page: 1)
        } catch {
            XCTAssertEqual(error as? GitHubError, GitHubError.serverError)
            XCTAssertEqual(client.getSearchHistory(maxCount: 100), [])
            return
        }
        XCTFail("expected an error to be thrown, but not.")
    }

    func testSearchHistory() async throws {
        try setUpMockSession(
            responseFileName: "search_success", statusCode: 200, rateLimitRemaining: 9)

        for i in 1...5 {
            let _ = try await client.search(query: "query \(i)", sortOrder: .bestMatch, page: 1)
        }
        XCTAssertEqual(
            client.getSearchHistory(maxCount: 10),
            (1...5).reversed().map { "query \($0)" }
        )
    }

    func testSearchHistoryOldestQueryDiscarded() async throws {
        try setUpMockSession(
            responseFileName: "search_success", statusCode: 200, rateLimitRemaining: 9)

        for i in 1...101 {
            let _ = try await client.search(query: "query \(i)", sortOrder: .bestMatch, page: 1)
        }
        XCTAssertEqual(
            client.getSearchHistory(maxCount: 100),
            (2...101).reversed().map { "query \($0)" }
        )
    }

    func testSearchHistoryReturnsMaxCountQueries() async throws {
        try setUpMockSession(
            responseFileName: "search_success", statusCode: 200, rateLimitRemaining: 9)

        for i in 1...101 {
            let _ = try await client.search(query: "query \(i)", sortOrder: .bestMatch, page: 1)
        }
        XCTAssertEqual(
            client.getSearchHistory(maxCount: 5),
            (97...101).reversed().map { "query \($0)" }
        )
    }

    func testSearchHistoryNegativeMaxCountReturnsEmptyArray() async throws {
        try setUpMockSession(
            responseFileName: "search_success", statusCode: 200, rateLimitRemaining: 9)

        let _ = try await client.search(query: "query", sortOrder: .bestMatch, page: 1)
        for i in 1...101 {
            let _ = try await client.search(query: "query \(i)", sortOrder: .bestMatch, page: 1)
        }
        XCTAssertEqual(
            client.getSearchHistory(maxCount: -1),
            []
        )
    }

    private func setUpMockSession(
        responseFileName: String, statusCode: Int, rateLimitRemaining: Int
    ) throws {
        let url = try XCTUnwrap(
            Bundle(for: type(of: self)).url(forResource: responseFileName, withExtension: "json"))
        let data = try XCTUnwrap(Data(contentsOf: url))
        session.dataHandler = { (request, _) async throws -> (Data, URLResponse) in
            (
                data,
                HTTPURLResponse(
                    url: try XCTUnwrap(request.url),
                    statusCode: statusCode,
                    httpVersion: nil,
                    headerFields: ["x-ratelimit-remaining": String(rateLimitRemaining)]
                )!
            )
        }
    }
}
