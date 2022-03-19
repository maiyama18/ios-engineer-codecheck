//
//  RepositorySearchFormSection.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositorySearchFormSection: View {
    let onSearchButtonTapped: () -> Void

    @Binding var query: String

    @FocusState private var focused: Bool
    @State private var isSearching: Bool = false

    var body: some View {
        HStack {
            TextField(L10n.SearchBar.placeholder, text: $query)
                .disableAutocorrection(true)
                .textFieldStyle(SearchFieldStyle())
                .submitLabel(.search)
                .onSubmit {
                    onSearchButtonTapped()
                }
                .accessibilityIdentifier("searchField")
                .focused($focused)

            if isSearching {
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
        .onChange(of: focused) { focused in
            withAnimation(.easeInOut(duration: 0.1)) {
                isSearching = focused
            }
        }
    }
}

struct RepositorySearchFormSection_Previews: PreviewProvider {
    static var previews: some View {
        RepositorySearchFormSection(
            onSearchButtonTapped: {},
            query: .constant("swift")
        )
    }
}
