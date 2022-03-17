//
//  RepositoryDetailPropertyView.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryDetailPropertyView: View {
    let iconSystemName: String
    let key: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: iconSystemName)
                .frame(width: 18)

            Text(key)
                .font(.callout)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            Spacer()

            Text(value)
                .font(.callout)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
