//
//  RepositorySearchEmptyView.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositorySearchEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.largeTitle)

            Text(L10n.RepositorySearch.searchRepositories)
                .font(.title2)
        }
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
