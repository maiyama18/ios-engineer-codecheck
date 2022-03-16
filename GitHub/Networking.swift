//
//  Networking.swift
//  GitHub
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// @mockable
public protocol Networking {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (
        Data, URLResponse
    )
}

extension URLSession: Networking {}
