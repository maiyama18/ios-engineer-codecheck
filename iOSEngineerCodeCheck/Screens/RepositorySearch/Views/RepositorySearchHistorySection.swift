//
//  RepositorySearchHistorySection.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositorySearchHistorySection: View {
    let searchHistory: [String]
    let onSearchHistoryTapped: @MainActor (String) -> Void
    let onSearchHistoryClearButtonTapped: @MainActor () -> Void

    var body: some View {
        ScrollView {
            if !searchHistory.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(L10n.RepositorySearch.history)
                            .font(.callout)
                            .foregroundColor(.secondary)

                        Spacer()

                        Button(
                            action: {
                                onSearchHistoryClearButtonTapped()
                            },
                            label: {
                                Text(L10n.Common.clear)
                                    .font(.callout)
                            })
                    }

                    Spacer()
                        .frame(height: 8)

                    Divider()

                    ForEach(searchHistory, id: \.self) { history in
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 4) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.secondary)

                                Text(history)
                            }
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onSearchHistoryTapped(history)
                            }

                            Divider()
                        }
                    }
                }
                .padding(.top, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct RepositorySearchHistorySection_Previews: PreviewProvider {
    static var previews: some View {
        RepositorySearchHistorySection(
            searchHistory: ["swift", "tableview", "type safe"],
            onSearchHistoryTapped: { _ in },
            onSearchHistoryClearButtonTapped: {}
        )
    }
}
