//
//  GitHubRequests.swift
//  GitHub
//
//  Created by maiyama on 2022/03/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

public enum SortOrder: String, CaseIterable {
    case bestMatch = "best-match"
    case stars
    case forks
    case updated
}

public let githubSearchPerPage = 30

public let githubSearchLanguages: [String] = [
    "C",
    "C#",
    "C++",
    "Clojure",
    "Crystal",
    "CSS",
    "Dart",
    "Elixir",
    "Elm",
    "Go",
    "Haskell",
    "HTML",
    "Java",
    "JavaScript",
    "Jupyter Notebook",
    "Kotlin",
    "Objective-C",
    "Perl",
    "PHP",
    "PowerShell",
    "Python",
    "R",
    "Ruby",
    "Rust",
    "Scala",
    "Shell",
    "Swift",
    "TypeScript",
]
