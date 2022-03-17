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
    
    public var message: String {
        switch self {
        case .invalidInput:
            return "Input may be invalid. Please review your input."
        case .tooManyRequests:
            return "You have sent too many request. Please try again later!"
        case .serverError:
            return "Server is now unavailable. Please try again later!"
        case .unexpectedError:
            return "Something went wrong. Please try again later!"
        }
    }
}
