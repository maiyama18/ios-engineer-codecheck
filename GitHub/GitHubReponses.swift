//
//  GitHubResponses.swift
//  GitHub
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

// ref: https://docs.github.com/ja/rest/reference/search#search-repositories

struct RepositorySearchResponse: Decodable {
    public let items: [RepositoryResponse]
}

struct RepositoryResponse: Decodable {
    public let fullName: String
    public let description: String?
    public let language: String?
    public let owner: UserResponse
    public let starsCount: Int
    public let watchersCount: Int
    public let forksCount: Int
    public let openIssuesCount: Int

    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
        case language
        case owner
        case starsCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}

struct UserResponse: Decodable {
    public let avatarURL: String

    public init(avatarURL: String) {
        self.avatarURL = avatarURL
    }

    private enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
