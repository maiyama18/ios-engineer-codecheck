//
//  RepositoryDetailRouting.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import GitHub
import UIKit

protocol RepositoryDetailRouting {
    func pushRepositoryDetail(from originVC: UIViewController, repository: Repository)
}

extension RepositoryDetailRouting {
    func pushRepositoryDetail(from originVC: UIViewController, repository: Repository) {
        let detailVC = RepositoryDetailViewController(
            viewModel: RepositoryDetailViewModel(repository: repository)
        )
        originVC.navigationController?.pushViewController(detailVC, animated: true)
    }
}
