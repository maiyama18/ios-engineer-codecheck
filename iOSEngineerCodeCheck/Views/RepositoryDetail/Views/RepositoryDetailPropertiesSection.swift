//
//  RepositoryDetailPropertiesSection.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryDetailPropertiesSection: View {
    let starsCount: String
    let forksCount: String
    let issuesCount: String
    let watchesCount: String

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                RepositoryDetailPropertyView(
                    iconSystemName: "star",
                    key: "Star",
                    value: starsCount
                )
                .frame(maxWidth: .infinity)

                RepositoryDetailPropertyView(
                    iconSystemName: "tuningfork",
                    key: "Fork",
                    value: forksCount
                )
                .frame(maxWidth: .infinity)
            }

            HStack(spacing: 8) {
                RepositoryDetailPropertyView(
                    iconSystemName: "smallcircle.filled.circle",
                    key: "Issue",
                    value: issuesCount
                )
                .frame(maxWidth: .infinity)

                RepositoryDetailPropertyView(
                    iconSystemName: "eye",
                    key: "Watch",
                    value: watchesCount
                )
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct RepositoryDetailPropertiesSection_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailPropertiesSection(
            starsCount: "2381",
            forksCount: "501",
            issuesCount: "16",
            watchesCount: "1052"
        )
        .padding()
    }
}
