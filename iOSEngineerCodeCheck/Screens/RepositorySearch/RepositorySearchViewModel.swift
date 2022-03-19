//
//  RepositorySearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import GitHub
import OSLog

final class RepositorySearchViewModel: ObservableObject {

    enum Event: Equatable {
        case navigateToDetail(repository: Repository)
        case showErrorAlert(message: String)
        case showLoading
        case hideLoading
    }

    @MainActor @Published var repositories: [Repository] = []
    @MainActor @Published var query: String = ""

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

    func onSearchButtonTapped() {
        eventSubject.send(.showLoading)
        task = Task { @MainActor in
            do {
                repositories = try await githubClient.search(query: query)
            } catch {
                logger.warning(
                    "failed to search repository: \(error.userMessage, privacy: .public)")
                eventSubject.send(.showErrorAlert(message: error.userMessage))
            }
            eventSubject.send(.hideLoading)
        }
    }

    func onRepositoryTapped(repository: Repository) {
        eventSubject.send(.navigateToDetail(repository: repository))
    }

}
