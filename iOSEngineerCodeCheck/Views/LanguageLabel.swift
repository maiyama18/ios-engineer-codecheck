//
//  LanguageLabel.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI
import GitHub

struct LanguageLabel: View {
    let language: Language
    
    var body: some View {
        HStack(spacing: 4) {
            if let colorCode = language.colorCode {
                Circle()
                    .fill(Color(hex: colorCode))
                    .frame(width: 16, height: 16)
            }
            
            Text(language.name)
                .font(.callout)
        }
    }
}
