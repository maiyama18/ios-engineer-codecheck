//
//  RepositoryListItemView.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import GitHub
import SwiftUI

struct RepositoryListItemView: View {
    let repository: Repository
    let onTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AvatarImage(
                    avatarURL: repository.avatarURL,
                    size: 24
                )

                Text(repository.fullName)
                    .font(.body)
                    .bold()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .accessibilityIdentifier("listRepositoryTitle")
            }

            HStack(spacing: 12) {
                if let language = repository.language {
                    LanguageLabel(language: language)
                }

                HStack(spacing: 4) {
                    Image(systemName: "star")

                    Text(String(repository.starsCount))
                        .font(.callout)
                }
                .foregroundColor(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "tuningfork")

                    Text(String(repository.forksCount))
                        .font(.callout)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            onTapped()
        }
    }
}
