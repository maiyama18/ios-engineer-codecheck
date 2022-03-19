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
    let items: [RepositoryResponse]
}

struct RepositoryResponse: Decodable {
    let fullName: String
    let description: String?
    let language: String?
    let owner: UserResponse
    let starsCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let htmlURL: String

    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
        case language
        case owner
        case starsCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case htmlURL = "html_url"
    }
}

struct UserResponse: Decodable {
    let avatarURL: String

    private enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
