//
//  Error+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import GitHub

extension Error {
    var userMessage: String {
        switch self {
        case let githubError as GitHubError:
            return githubError.message
        default:
            return "Something went wrong. Please try again later!"
        }
    }
}
