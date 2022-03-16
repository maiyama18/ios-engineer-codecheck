//
//  Repository+Extension.swift
//  iOSEngineerCodeCheckTests
//
//  Created by maiyama on 2022/03/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import GitHub

extension Repository {
    static func mock(fullName: String) -> Repository {
        .init(
            fullName: fullName,
            language: "Swift",
            owner: User(avatarURL: "http://example.com/avatars/1"),
            starsCount: 100,
            watchersCount: 50,
            forksCount: 10,
            openIssuesCount: 5
        )
    }
}
