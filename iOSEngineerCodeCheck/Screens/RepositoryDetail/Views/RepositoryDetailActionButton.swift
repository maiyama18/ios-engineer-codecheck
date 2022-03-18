//
//  RepositoryDetailActionButton.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryDetailActionButton: View {
    let iconSystemName: String
    let title: String
    let onTapped: () -> Void
    
    var body: some View {
        Button(
            action: {
                onTapped()
            },
            label: {
                HStack(spacing: 8) {
                    Image(systemName: iconSystemName)
                        .frame(width: 24)
                    
                    Text(title)
                        .font(.callout)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        )
    }
}
