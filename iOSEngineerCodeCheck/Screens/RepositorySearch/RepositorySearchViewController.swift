//
//  RepositorySearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import GitHub
import UIKit

class RepositorySearchViewController: UIViewController, RepositoryDetailRouting {

    private var cancellables: [AnyCancellable] = []

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let viewModel = RepositorySearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        subscribe()
        hostSwiftUIView(RepositorySearchScreen(viewModel: viewModel))
    }

    private func setupNavigationBar() {
        title = "Search Repositories"
    }

    private func subscribe() {
        viewModel.events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }

                switch event {
                case .navigateToDetail(let repository):
                    self.pushRepositoryDetail(from: self, repository: repository)
                }
            }
            .store(in: &cancellables)
    }

}
