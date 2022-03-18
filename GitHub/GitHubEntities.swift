//
//  GitHubEntities.swift
//  GitHub
//
//  Created by maiyama on 2022/03/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

public struct Repository: Equatable {
    public let fullName: String
    public let description: String?
    public let language: Language?
    public let avatarURL: URL?
    public let starsCount: Int
    public let watchersCount: Int
    public let forksCount: Int
    public let openIssuesCount: Int

    public init(
        fullName: String, description: String?, language: Language?, avatarURL: URL?,
        starsCount: Int, watchersCount: Int, forksCount: Int, openIssuesCount: Int
    ) {
        self.fullName = fullName
        self.description = description
        self.language = language
        self.avatarURL = avatarURL
        self.starsCount = starsCount
        self.watchersCount = watchersCount
        self.forksCount = forksCount
        self.openIssuesCount = openIssuesCount
    }
}

public struct Language: Equatable {
    public let name: String
    public let colorCode: String?

    public init(name: String, colorCode: String?) {
        self.name = name
        self.colorCode = colorCode
    }
}
