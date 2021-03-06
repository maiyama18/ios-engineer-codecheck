//
//  RepositorySearchResultsSection.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import GitHub
import SwiftUI

struct RepositorySearchResultsSection: View {
    let repositories: [Repository]
    let isSearching: Bool
    let onRepositoryTapped: @MainActor (Repository) -> Void
    let onScrollBottomReached: @MainActor () -> Void

    @Namespace var topViewID

    var body: some View {
        if repositories.isEmpty, !isSearching {
            RepositorySearchEmptyView()
        } else {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    Color.clear
                        .frame(width: 0, height: 0, alignment: .top)
                        .id(topViewID)

                    LazyVStack {
                        ForEach(repositories, id: \.fullName) { repository in
                            VStack {
                                RepositoryListItemView(
                                    repository: repository,
                                    onTapped: {
                                        onRepositoryTapped(repository)
                                    }
                                )

                                Divider()
                            }
                            .onAppear {
                                if repository.fullName == repositories.last?.fullName {
                                    onScrollBottomReached()
                                }
                            }
                        }
                    }
                }
                .onChange(of: repositories) { repositories in
                    if repositories.count <= githubSearchPerPage {
                        proxy.scrollTo(topViewID)
                    }
                }
            }
        }
    }
}

struct RepositorySearchResultsSection_Previews: PreviewProvider {
    static var previews: some View {
        RepositorySearchResultsSection(
            repositories: [],
            isSearching: false,
            onRepositoryTapped: { _ in },
            onScrollBottomReached: {}
        )
    }
}
