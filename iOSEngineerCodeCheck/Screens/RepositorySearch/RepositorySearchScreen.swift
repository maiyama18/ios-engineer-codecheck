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
                languageCandidates: viewModel.languageCandidates,
                query: $viewModel.query,
                isEditingQuery: $viewModel.isEditingQuery,
                sortOrder: $viewModel.sortOrder,
                language: $viewModel.language
            )

            RepositorySearchResultsSection(
                repositories: viewModel.repositories,
                searchedPage: viewModel.lastSearchedPage,
                onRepositoryTapped: viewModel.onRepositoryTapped(repository:),
                onScrollBottomReached: viewModel.onScrollBottomReached
            )
        }
        .padding(.top)
        .padding(.horizontal)
    }
}
