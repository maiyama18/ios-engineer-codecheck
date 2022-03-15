//
//  GitHubClient.swift
//  GitHub
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

public protocol GitHubClientProtocol {
    func search(query: String) async throws -> [Repository]
}

public final class GitHubClient: GitHubClientProtocol {
    public static let shared = GitHubClient(session: URLSession.shared)

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    public func search(query: String) async throws -> [Repository] {
        guard !query.isEmpty else {
            throw GitHubError.invalidInput
        }

        var components = URLComponents(string: "https://api.github.com/search/repositories")!
        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]

        guard let url = components.url else { throw GitHubError.invalidInput }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request, delegate: nil)
        guard let response = response as? HTTPURLResponse else {
            throw GitHubError.unexpectedError
        }

        switch response.statusCode {
        case 200:
            let response = try JSONDecoder().decode(RepositorySearchResponse.self, from: data)
            return response.items
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
}