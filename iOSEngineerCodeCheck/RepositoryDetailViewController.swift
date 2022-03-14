//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {

    @IBOutlet weak private var avatarImageView: UIImageView!

    @IBOutlet weak private var titleLabel: UILabel!

    @IBOutlet weak private var languageLabel: UILabel!

    @IBOutlet weak private var starsLabel: UILabel!
    @IBOutlet weak private var watchersLabel: UILabel!
    @IBOutlet weak private var forksLabel: UILabel!
    @IBOutlet weak private var openIssuesLabel: UILabel!

    var repository: [String: Any]!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = repository["full_name"] as? String
        if let language = repository["language"] as? String {
            languageLabel.text = "Written in \(language)"
        } else {
            languageLabel.text = nil
        }
        starsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repository["watchers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        openIssuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        setupAvatarImage(repository: repository)
    }

    func setupAvatarImage(repository: [String: Any]) {
        guard let owner = repository["owner"] as? [String: Any],
            let avatarURL = owner["avatar_url"] as? String
        else {
            return
        }

        URLSession.shared.dataTask(with: URL(string: avatarURL)!) { (data, res, err) in
            let image = UIImage(data: data!)!
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }.resume()
    }

}
