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
    "Assembly",
    "BASIC",
    "Brainfuck",
    "C",
    "C#",
    "C++",
    "Clojure",
    "Crystal",
    "CSS",
    "D",
    "Dart",
    "Elixir",
    "Elm",
    "Erlang",
    "F#",
    "Fortran",
    "Go",
    "Groovy",
    "Haskell",
    "HTML",
    "Java",
    "JavaScript",
    "Jupyter Notebook",
    "Kotlin",
    "Lua",
    "Markdown",
    "Nim",
    "Objective-C",
    "OCaml",
    "Pascal",
    "Perl",
    "PHP",
    "PowerShell",
    "Processing",
    "Python",
    "R",
    "Ruby",
    "Rust",
    "Scala",
    "Shell",
    "Swift",
    "TypeScript",
]
