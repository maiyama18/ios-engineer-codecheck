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

    private var eventSubscription: Task<Void, Never>?

    private let viewModel: RepositoryDetailViewModel

    init(viewModel: RepositoryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
        hostSwiftUIView(RepositoryDetailScreen(viewModel: viewModel))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        eventSubscription?.cancel()
    }

    private func subscribe() {
        eventSubscription?.cancel()
        eventSubscription = Task {
            for await event in viewModel.eventStream {
                switch event {
                case .openURL(let url):
                    await UIApplication.shared.open(url)
                case .shareURL(let url):
                    let shareVC = UIActivityViewController(
                        activityItems: [url], applicationActivities: nil)
                    self.present(shareVC, animated: true)
                }
            }
        }
    }

}
