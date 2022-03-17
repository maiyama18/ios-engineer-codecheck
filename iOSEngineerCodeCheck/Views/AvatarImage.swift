//
//  AvatarImage.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct AvatarImage: View {
    let avatarURL: URL?
    let size: CGFloat
    
    var body: some View {
        AsyncImage(
            url: avatarURL,
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .cornerRadius(8)
            },
            placeholder: {
                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(width: size, height: size)
                    .cornerRadius(8)
            }
        )
    }
}
