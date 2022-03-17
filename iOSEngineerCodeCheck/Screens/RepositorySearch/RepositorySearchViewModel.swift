//
//  RepositorySearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import GitHub

final class RepositorySearchViewModel: ObservableObject {

    enum Event {
        case navigateToDetail(repository: Repository)
    }

    @MainActor @Published var repositories: [Repository] = []

    private var task: Task<Void, Never>?

    private let eventSubject: PassthroughSubject<Event, Never> = .init()
    var events: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }

    private let githubClient: GitHubClientProtocol

    init(githubClient: GitHubClientProtocol = GitHubClient.shared) {
        self.githubClient = githubClient
    }

    func onSearchTextChanged() {
        task?.cancel()
    }

    func onSearchButtonTapped(query: String) {
        task = Task { @MainActor in
            do {
                repositories = try await githubClient.search(query: query)
            } catch {
                // TODO: エラーハンドリング
            }
        }
    }

    func onRepositoryTapped(repository: Repository) {
        eventSubject.send(.navigateToDetail(repository: repository))
    }

}
