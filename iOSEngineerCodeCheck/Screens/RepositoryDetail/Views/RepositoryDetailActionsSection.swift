//
//  RepositoryDetailActionsSection.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryDetailActionsSection: View {
    let onOpenURLTapped: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            RepositoryDetailActionButton(
                iconSystemName: "safari",
                title: L10n.RepositoryDetail.openUrl,
                onTapped: onOpenURLTapped
            )
        }
    }
}

struct RepositoryDetailActionsSection_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailActionsSection(
            onOpenURLTapped: {}
        )
    }
}
