//
//  SearchFieldStyle.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct SearchFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 8)
            .padding(.leading, 32)
            .padding(.trailing, 12)
            .overlay {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .padding(.leading, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
    }
}
