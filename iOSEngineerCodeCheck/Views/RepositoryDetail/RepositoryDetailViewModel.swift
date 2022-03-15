//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import GitHub
import UIKit

final class RepositoryDetailViewModel {

    enum Event {
        case avatarImageLoaded(image: UIImage)
    }

    private let eventSubject: PassthroughSubject<Event, Never> = .init()
    var events: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }

    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    var titleText: String {
        repository.fullName
    }

    var languageText: String? {
        if let language = repository.language {
            return "Written in \(language)"
        } else {
            return nil
        }
    }

    var starsText: String {
        "\(repository.starsCount) stars"
    }

    var watchersText: String {
        "\(repository.watchersCount) watchers"
    }

    var forksText: String {
        "\(repository.forksCount) forks"
    }

    var openIssuesText: String {
        "\(repository.openIssuesCount) open issues"
    }

    func onViewLoaded() {
        loadAvatarImage()
    }

    private func loadAvatarImage() {
        guard let avatarURL = URL(string: repository.owner.avatarURL) else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: avatarURL, delegate: nil)
                guard let image = UIImage(data: data) else { return }
                eventSubject.send(.avatarImageLoaded(image: image))
            } catch {
                // TODO: エラーハンドリング
            }
        }
    }

}
