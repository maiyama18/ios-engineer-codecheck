//
//  Color+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

extension Color {
    /// `AA11FF` 形式の hex string から Color を生成する
    init(hex: String) {
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r: UInt64
        let g: UInt64
        let b: UInt64
        (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}
