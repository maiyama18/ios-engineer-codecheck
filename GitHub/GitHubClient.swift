//
//  GitHubClient.swift
//  GitHub
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// @mockable
public protocol GitHubClientProtocol {
    /// レポジトリを検索する
    func search(query: String, sortOrder: SortOrder, page: Int, language: String?) async throws
        -> [Repository]
    /// 検索クエリの履歴を最大100件まで返す
    func getSearchHistory(maxCount: Int) -> [String]
}

public final class GitHubClient: GitHubClientProtocol {
    public static let shared = GitHubClient(
        session: URLSession.shared, userDefaults: UserDefaults.standard)

    private let searchHistoryCapacity = 100

    private let session: Networking
    private let userDefaults: UserDefaults

    init(session: Networking, userDefaults: UserDefaults) {
        self.session = session
        self.userDefaults = userDefaults
    }

    public func search(query: String, sortOrder: SortOrder, page: Int, language: String? = nil)
        async throws
        -> [Repository]
    {
        guard !query.isEmpty else {
            throw GitHubError.emptySearchQuery
        }

        var components = URLComponents(string: "https://api.github.com/search/repositories")!

        let q: String
        if let language = language {
            q = "\(query) language:\(language)"
        } else {
            q = query
        }
        components.queryItems = [
            .init(name: "q", value: q),
            .init(name: "sort", value: sortOrder.rawValue),
            .init(name: "page", value: String(page)),
            .init(name: "per_page", value: String(githubSearchPerPage)),
        ]

        guard let url = components.url else { throw GitHubError.invalidInput }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request, delegate: nil)
        guard let response = response as? HTTPURLResponse else {
            throw GitHubError.unexpectedError
        }
        if let method = request.httpMethod,
            let url = request.url?.absoluteString,
            let json = data.prettyPrintedJSONString
        {
            logger.info(
                "request: \(method) \(url)\nresponse: \(response.statusCode) \(json)"
            )
        }

        switch response.statusCode {
        case 200:
            let response = try JSONDecoder().decode(RepositorySearchResponse.self, from: data)

            self.addToSearchHistory(query: query)
            return response.items.map { item in
                let language: Language?
                if let lang = item.language {
                    language = Language(name: lang, colorCode: githubColors[lang])
                } else {
                    language = nil
                }

                return Repository(
                    fullName: item.fullName,
                    description: item.description,
                    language: language,
                    avatarURL: URL(string: item.owner.avatarURL),
                    starsCount: item.starsCount,
                    watchersCount: item.watchersCount,
                    forksCount: item.forksCount,
                    openIssuesCount: item.openIssuesCount,
                    repositoryURL: URL(string: item.htmlURL)
                )
            }
        case 400..<500:
            // ref: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limit-http-headers
            if let rateLimitRemainingString = response.allHeaderFields["x-ratelimit-remaining"]
                as? String,
                Int(rateLimitRemainingString) == 0
            {
                throw GitHubError.tooManyRequests
            } else {
                throw GitHubError.invalidInput
            }
        case 500:
            throw GitHubError.serverError
        default:
            throw GitHubError.unexpectedError
        }
    }

    public func getSearchHistory(maxCount: Int) -> [String] {
        // 渡された maxCount を 0...100 の範囲に clamp する
        let count = max(0, min(searchHistoryCapacity, maxCount))
        return Array(userDefaults.searchHistory.prefix(count))
    }

    private func addToSearchHistory(query: String) {
        let currentHistory = userDefaults.searchHistory
        // 最新の検索履歴を最大100件まで保持する
        userDefaults.searchHistory = Array(([query] + currentHistory).prefix(searchHistoryCapacity))
    }
}
