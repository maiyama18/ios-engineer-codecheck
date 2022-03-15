//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
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

    private var cancellables: [AnyCancellable] = []

    private let viewModel: RepositoryDetailViewModel

    init?(coder: NSCoder, viewModel: RepositoryDetailViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTexts()
        subscribe()
        viewModel.onViewLoaded()
    }

    private func setupTexts() {
        titleLabel.text = viewModel.titleText
        languageLabel.text = viewModel.languageText
        starsLabel.text = viewModel.starsText
        watchersLabel.text = viewModel.watchersText
        forksLabel.text = viewModel.forksText
        openIssuesLabel.text = viewModel.openIssuesText
    }

    private func subscribe() {
        viewModel.events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }

                switch event {
                case .avatarImageLoaded(let image):
                    self.avatarImageView.image = image
                }
            }
            .store(in: &cancellables)
    }

}
