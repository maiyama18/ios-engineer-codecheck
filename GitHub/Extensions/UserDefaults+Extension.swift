//
//  UserDefaults+Extension.swift
//  GitHub
//
//  Created by maiyama on 2022/03/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

extension UserDefaults {
    var searchHistory: [String] {
        get {
            array(forKey: "search_history") as? [String] ?? []
        }
        set {
            set(newValue, forKey: "search_history")
        }
    }
}
