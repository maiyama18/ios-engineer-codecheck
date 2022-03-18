//
//  GitHubError.swift
//  GitHub
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

public enum GitHubError: Error {
    case emptySearchQuery
    case invalidInput
    case tooManyRequests
    case serverError
    case unexpectedError

}
