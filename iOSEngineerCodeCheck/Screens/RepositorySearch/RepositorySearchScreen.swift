//
//  RepositorySearchScreen.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositorySearchScreen: View {
    @ObservedObject var viewModel: RepositorySearchViewModel

    var body: some View {
        VStack(spacing: 12) {
            RepositorySearchFormSection(
                onSearchButtonTapped: viewModel.onSearchButtonTapped,
                query: $viewModel.query,
                sortOrder: $viewModel.sortOrder
            )

            RepositorySearchResultsSection(
                repositories: viewModel.repositories,
                onRepositoryTapped: viewModel.onRepositoryTapped(repository:)
            )
        }
        .padding()
    }
}
