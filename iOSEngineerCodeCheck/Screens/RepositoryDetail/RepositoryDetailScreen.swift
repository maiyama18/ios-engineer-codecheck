//
//  RepositoryDetailScreen.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryDetailScreen: View {
    let viewModel: RepositoryDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                RepositoryDetailHeaderSection(
                    avatarURL: viewModel.avatarURL,
                    organization: viewModel.organization,
                    repositoryName: viewModel.repositoryName,
                    description: viewModel.description,
                    language: viewModel.language
                )

                RepositoryDetailPropertiesSection(
                    starsCount: viewModel.starsCount,
                    forksCount: viewModel.forksCount,
                    issuesCount: viewModel.issuesCount,
                    watchesCount: viewModel.watchesCount
                )

                RepositoryDetailActionsSection(
                    onOpenURLTapped: viewModel.onOpenURLTapped,
                    onShareURLTapped: viewModel.onShareURLTapped
                )
            }
            .padding()
        }
    }
}
