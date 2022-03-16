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
    private let session: Networking

    init(repository: Repository, session: Networking = URLSession.shared) {
        self.repository = repository
        self.session = session
    }

    var titleText: String {
        repository.fullName
    }

    var languageText: String? {
        if let language = repository.language {
            return "Written in \(language.name)"
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
        guard let avatarURL = repository.avatarURL else { return }

        Task {
            do {
                let (data, _) = try await session.data(
                    for: URLRequest(url: avatarURL), delegate: nil)
                guard let image = UIImage(data: data) else { return }
                eventSubject.send(.avatarImageLoaded(image: image))
            } catch {
                // TODO: エラーハンドリング
            }
        }
    }

}
