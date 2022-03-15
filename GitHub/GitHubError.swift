//
//  GitHubError.swift
//  GitHub
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

public enum GitHubError: Error {
    case invalidInput
    case tooManyRequests
    case serverError
    case unexpectedError
}
