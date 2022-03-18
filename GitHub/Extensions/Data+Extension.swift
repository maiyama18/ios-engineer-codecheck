//
//  Data+Extension.swift
//  GitHub
//
//  Created by maiyama on 2022/03/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import OSLog

extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(
                withJSONObject: object, options: [.prettyPrinted])
        else { return nil }

        return String(data: data, encoding: .utf8)
    }
}
