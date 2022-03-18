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
            switch githubError {
            case .emptySearchQuery:
                return L10n.Error.emptySearchQuery
            case .invalidInput:
                return L10n.Error.invalidInput
            case .tooManyRequests:
                return L10n.Error.tooManyRequest
            case .serverError:
                return L10n.Error.serverError
            case .unexpectedError:
                return L10n.Error.unexpectedError
            }
        default:
            return L10n.Error.unexpectedError
        }
    }
}
