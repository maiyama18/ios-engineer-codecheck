//
//  RepositorySearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import GitHub

final class RepositorySearchViewModel {

    enum Event {
        case unfocusFromSearchBar
        case reloadData
    }

    private var repositories: [Repository] = []

    private var task: Task<Void, Never>?

    private let eventSubject: PassthroughSubject<Event, Never> = .init()
    var events: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }

    private let githubClient: GitHubClientProtocol

    init(githubClient: GitHubClientProtocol = GitHubClient.shared) {
        self.githubClient = githubClient
    }

    func repositoriesCount() -> Int {
        repositories.count
    }

    func repository(index: Int) -> Repository? {
        repositories[safe: index]
    }

    func onSearchTextChanged() {
        task?.cancel()
    }

    func onSearchButtonTapped(query: String) {
        eventSubject.send(.unfocusFromSearchBar)

        task = Task {
            do {
                repositories = try await githubClient.search(query: query)
                eventSubject.send(.reloadData)
            } catch {
                // TODO: エラーハンドリング
            }
        }
    }

}
