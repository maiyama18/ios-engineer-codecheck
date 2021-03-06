//
//  RepositoryDetailHeaderSection.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import GitHub
import SwiftUI

struct RepositoryDetailHeaderSection: View {
    let avatarURL: URL?
    let organization: String
    let repositoryName: String
    let description: String?
    let language: Language?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                AvatarImage(
                    avatarURL: avatarURL,
                    size: 32
                )

                Text(organization)
                    .font(.callout)
                    .bold()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .accessibilityIdentifier("organizationText")
            }

            Text(repositoryName)
                .font(.title)
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            if let description = description {
                Text(description)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }

            if let language = language {
                LanguageLabel(language: language)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailHeaderSection(
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/22269397?v=4"),
            organization: "maiyama18",
            repositoryName: "AwesomeProject",
            description:
                "This project is awesome. Because this project is awesome. It's going to be more awesome in the future!",
            language: Language(name: "Swift", colorCode: "F05138")
        )
        .padding()
    }
}
