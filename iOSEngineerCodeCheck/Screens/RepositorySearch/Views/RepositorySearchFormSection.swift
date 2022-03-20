//
//  RepositorySearchFormSection.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import GitHub
import SwiftUI

struct RepositorySearchFormSection: View {
    let onSearchButtonTapped: @MainActor () -> Void
    let languageCandidates: [String]

    @Binding var query: String
    @Binding var isEditingQuery: Bool
    @Binding var sortOrder: GitHub.SortOrder
    @Binding var language: String

    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                TextField(L10n.SearchBar.placeholder, text: $query)
                    .disableAutocorrection(true)
                    .textFieldStyle(SearchFieldStyle())
                    .submitLabel(.search)
                    .onSubmit {
                        onSearchButtonTapped()
                    }
                    .accessibilityIdentifier("searchField")
                    .focused($focused)

                if isEditingQuery {
                    Button(
                        action: {
                            focused = false
                        },
                        label: {
                            Text(L10n.Common.cancel)
                        }
                    )
                }
            }

            if !isEditingQuery {
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down")
                            .font(.callout)
                            .foregroundColor(.accentColor)

                        Picker("", selection: $sortOrder) {
                            ForEach(SortOrder.allCases, id: \.self) { order in
                                Text(order.string)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    HStack {
                        Picker("", selection: $language) {
                            ForEach(languageCandidates, id: \.self) { language in
                                Text(language)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onChange(of: focused) { focused in
            withAnimation(.easeInOut(duration: 0.1)) {
                isEditingQuery = focused
            }
        }
        .onChange(of: isEditingQuery) { isEditingQuery in
            focused = isEditingQuery
        }
    }
}

struct RepositorySearchFormSection_Previews: PreviewProvider {
    static var previews: some View {
        RepositorySearchFormSection(
            onSearchButtonTapped: {},
            languageCandidates: ["Swift", "Kotlin"],
            query: .constant("swift"),
            isEditingQuery: .constant(true),
            sortOrder: .constant(.bestMatch),
            language: .constant("Swift")
        )
    }
}
