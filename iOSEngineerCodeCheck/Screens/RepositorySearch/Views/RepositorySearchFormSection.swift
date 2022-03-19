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
    let onSearchButtonTapped: () -> Void

    @Binding var query: String
    @Binding var sortOrder: GitHub.SortOrder

    @FocusState private var focused: Bool
    @State private var isEditingQuery: Bool = false

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

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down")
                        .font(.callout)
                        .foregroundColor(.accentColor)

                    Picker("", selection: $sortOrder) {
                        ForEach(SortOrder.allCases, id: \.self) { order in
                            Text(order.string)
                        }
                    }
                }

                Spacer()
            }
        }
        .onChange(of: focused) { focused in
            withAnimation(.easeInOut(duration: 0.1)) {
                isEditingQuery = focused
            }
        }
    }
}

struct RepositorySearchFormSection_Previews: PreviewProvider {
    static var previews: some View {
        RepositorySearchFormSection(
            onSearchButtonTapped: {},
            query: .constant("swift"),
            sortOrder: .constant(.bestMatch)
        )
    }
}
