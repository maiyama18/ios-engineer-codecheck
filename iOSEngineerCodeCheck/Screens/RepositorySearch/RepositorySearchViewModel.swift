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

    enum Event: Equatable {
        case navigateToDetail(repository: Repository)
        case showErrorAlert(message: String)
        case showLoading
        case hideLoading
    }

    @MainActor @Published var repositories: [Repository] = []
    @MainActor @Published var query: String = "" {
        didSet {
            onQueryChanged()
        }
    }
    @MainActor @Published var sortOrder: SortOrder = .bestMatch {
        didSet {
            onSortOrderChanged()
        }
    }
    @MainActor @Published var language: String = L10n.GitHub.Search.allLanguages {
        didSet {
            onLanguageChanged()
        }
    }

    private var task: Task<Void, Never>?
    private var lastSearchedQuery: String?

    private let eventSubject: PassthroughSubject<Event, Never> = .init()
    var events: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }

    private let githubClient: GitHubClientProtocol

    init(githubClient: GitHubClientProtocol = GitHubClient.shared) {
        self.githubClient = githubClient
    }

    var languageCandidates: [String] {
        [L10n.GitHub.Search.allLanguages] + githubSearchLanguages
    }

    func onSearchButtonTapped() {
        search()
    }

    func onRepositoryTapped(repository: Repository) {
        eventSubject.send(.navigateToDetail(repository: repository))
    }

    private func onQueryChanged() {
        task?.cancel()
    }

    private func onSortOrderChanged() {
        Task { @MainActor in
            // 前回の検索時からクエリが変わっていない場合、ソート順の変更で即座に検索し直すことが期待されていると考え検索を実行する
            // クエリが変わっている場合は次に検索ボタンがタップされるまで検索しない
            if let lastSearchedQuery = lastSearchedQuery, query == lastSearchedQuery {
                search()
            }
        }
    }

    private func onLanguageChanged() {
        Task { @MainActor in
            // 前回の検索時からクエリが変わっていない場合、言語の変更で即座に検索し直すことが期待されていると考え検索を実行する
            // クエリが変わっている場合は次に検索ボタンがタップされるまで検索しない
            if let lastSearchedQuery = lastSearchedQuery, query == lastSearchedQuery {
                search()
            }
        }
    }

    private func search() {
        task?.cancel()
        task = Task { @MainActor in
            guard !query.isEmpty else { return }

            eventSubject.send(.showLoading)
            do {
                let lang = language == L10n.GitHub.Search.allLanguages ? nil : language
                repositories = try await githubClient.search(
                    query: query, sortOrder: sortOrder, language: lang)
                lastSearchedQuery = query
            } catch {
                logger.warning(
                    "failed to search repository: \(error.userMessage, privacy: .public)")
                eventSubject.send(.showErrorAlert(message: error.userMessage))
            }
            eventSubject.send(.hideLoading)
        }
    }

}
