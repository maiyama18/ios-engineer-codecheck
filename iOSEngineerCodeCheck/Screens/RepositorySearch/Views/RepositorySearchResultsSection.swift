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
    let onRepositoryTapped: (Repository) -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
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
                }
            }
        }
    }
}

struct RepositorySearchResultsSection_Previews: PreviewProvider {
    static var previews: some View {
        RepositorySearchResultsSection(
            repositories: [],
            onRepositoryTapped: { _ in }
        )
    }
}
