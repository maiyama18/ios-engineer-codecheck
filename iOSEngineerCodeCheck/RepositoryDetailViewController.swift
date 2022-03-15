//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import GitHub
import UIKit

class RepositoryDetailViewController: UIViewController {

    @IBOutlet weak private var avatarImageView: UIImageView!

    @IBOutlet weak private var titleLabel: UILabel!

    @IBOutlet weak private var languageLabel: UILabel!

    @IBOutlet weak private var starsLabel: UILabel!
    @IBOutlet weak private var watchersLabel: UILabel!
    @IBOutlet weak private var forksLabel: UILabel!
    @IBOutlet weak private var openIssuesLabel: UILabel!

    private let repository: Repository

    init?(coder: NSCoder, repository: Repository) {
        self.repository = repository
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = repository.fullName
        if let language = repository.language {
            languageLabel.text = "Written in \(language)"
        } else {
            languageLabel.text = nil
        }
        starsLabel.text = "\(repository.starsCount) stars"
        watchersLabel.text = "\(repository.watchersCount) watchers"
        forksLabel.text = "\(repository.forksCount) forks"
        openIssuesLabel.text = "\(repository.openIssuesCount) open issues"
        setupAvatarImage(repository: repository)
    }

    func setupAvatarImage(repository: Repository) {
        guard let avatarURL = URL(string: repository.owner.avatarURL) else {
            return
        }

        URLSession.shared.dataTask(with: avatarURL) { (data, res, err) in
            guard let data = data,
                let image = UIImage(data: data)
            else {
                return
            }
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }.resume()
    }

}
