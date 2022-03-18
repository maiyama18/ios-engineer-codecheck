//
//  RepositorySearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import GitHub
import PKHUD
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

        subscribe()
        hostSwiftUIView(RepositorySearchScreen(viewModel: viewModel))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }

    private func subscribe() {
        viewModel.events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }

                switch event {
                case .navigateToDetail(let repository):
                    self.pushRepositoryDetail(from: self, repository: repository)
                case .showErrorAlert(let message):
                    self.showErrorAlert(message: message)
                case .showLoading:
                    HUD.show(.progress)
                case .hideLoading:
                    HUD.hide()
                }
            }
            .store(in: &cancellables)
    }

}
