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

    enum Event: Equatable {
        case openURL(url: URL)
        case shareURL(url: URL)
    }

    private let repository: Repository
    private let session: Networking

    private var eventContinuation: AsyncStream<Event>.Continuation?
    var eventStream: AsyncStream<Event>!

    init(repository: Repository, session: Networking = URLSession.shared) {
        self.repository = repository
        self.session = session

        eventStream = .init(Event.self, bufferingPolicy: .bufferingNewest(10)) { c in
            eventContinuation = c
        }
    }

    var avatarURL: URL? {
        repository.avatarURL
    }

    var organization: String {
        String(repository.fullName.split(separator: "/")[safe: 0] ?? "")
    }

    var repositoryName: String {
        String(repository.fullName.split(separator: "/")[safe: 1] ?? "")
    }

    var description: String? {
        repository.description
    }

    var language: Language? {
        repository.language
    }

    var starsCount: String {
        String(repository.starsCount)
    }

    var watchesCount: String {
        String(repository.watchersCount)
    }

    var forksCount: String {
        String(repository.forksCount)
    }

    var issuesCount: String {
        String(repository.openIssuesCount)
    }

    func onOpenURLTapped() {
        guard let url = repository.repositoryURL else { return }
        eventContinuation?.yield(.openURL(url: url))
    }

    func onShareURLTapped() {
        guard let url = repository.repositoryURL else { return }
        eventContinuation?.yield(.shareURL(url: url))
    }

}
