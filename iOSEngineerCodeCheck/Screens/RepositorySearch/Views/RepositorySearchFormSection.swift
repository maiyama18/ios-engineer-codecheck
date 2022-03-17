//
//  RepositorySearchFormSection.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositorySearchFormSection: View {
    let onSearchButtonTapped: (String) -> Void

    @State private var query = ""

    var body: some View {
        TextField("Search...", text: $query)
            .textFieldStyle(SearchFieldStyle())
            .submitLabel(.search)
            .onSubmit {
                onSearchButtonTapped(query)
            }
    }
}

struct RepositorySearchFormSection_Previews: PreviewProvider {
    static var previews: some View {
        RepositorySearchFormSection(
            onSearchButtonTapped: { _ in }
        )
    }
}
