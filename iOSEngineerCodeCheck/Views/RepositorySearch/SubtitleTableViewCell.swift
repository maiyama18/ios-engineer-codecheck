//
//  SubtitleTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/14.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
