//
//  Repository+Extension.swift
//  iOSEngineerCodeCheckTests
//
//  Created by maiyama on 2022/03/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import GitHub

extension Repository {
    static func mock(
        fullName: String, starsCount: Int = 100,
        language: Language = Language(name: "C++", colorCode: "112233")
    ) -> Repository {
        .init(
            fullName: fullName,
            description: "Description",
            language: language,
            avatarURL: URL(string: "http://example.com/avatars/1"),
            starsCount: starsCount,
            watchersCount: 50,
            forksCount: 10,
            openIssuesCount: 5,
            repositoryURL: URL(string: "https://github.com/apple/swift")
        )
    }
}
