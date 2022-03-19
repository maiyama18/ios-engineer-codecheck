//
//  GitHub+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import GitHub

extension SortOrder {
    var string: String {
        switch self {
        case .bestMatch:
            return L10n.GitHub.SortOrder.bestMatch
        case .stars:
            return L10n.GitHub.SortOrder.stars
        case .forks:
            return L10n.GitHub.SortOrder.forks
        case .updated:
            return L10n.GitHub.SortOrder.updated
        }
    }
}
