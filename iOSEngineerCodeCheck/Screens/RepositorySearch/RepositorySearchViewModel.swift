//
//  RepositorySearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import GitHub

@MainActor
final class RepositorySearchViewModel: ObservableObject {

    enum Event: Equatable {
        case navigateToDetail(repository: Repository)
        case showErrorAlert(message: String)
        case showLoading
        case hideLoading
    }

    @Published var repositories: [Repository] = []
    @Published var query: String = ""
    @Published var isEditingQuery: Bool = false
    @Published var sortOrder: SortOrder = .bestMatch {
        didSet {
            onSortOrderChanged()
        }
    }
    @Published var language: String = L10n.GitHub.Search.allLanguages {
        didSet {
            onLanguageChanged()
        }
    }

    var lastSearchedPage: Int?

    private var task: Task<Void, Never>?
    private var lastSearchedQuery: String?

    private var eventContinuation: AsyncStream<Event>.Continuation?
    var eventStream: AsyncStream<Event>!

    private let githubClient: GitHubClientProtocol

    init(githubClient: GitHubClientProtocol = GitHubClient.shared) {
        self.githubClient = githubClient

        eventStream = .init(Event.self, bufferingPolicy: .bufferingNewest(10)) { c in
            eventContinuation = c
        }
    }

    var languageCandidates: [String] {
        [L10n.GitHub.Search.allLanguages] + githubSearchLanguages
    }

    var recentSearchHistory: [String] {
        githubClient.getSearchHistory(maxCount: 5)
    }

    func onSearchButtonTapped() {
        search()
    }

    func onRepositoryTapped(repository: Repository) {
        eventContinuation?.yield(.navigateToDetail(repository: repository))
    }

    func onScrollBottomReached() {
        guard !repositories.isEmpty, repositories.count % githubSearchPerPage == 0 else {
            return
        }
        searchMore()
    }

    func onSearchHistoryTapped(query: String) {
        self.query = query
        isEditingQuery = false
        search()
    }

    private func onSortOrderChanged() {
        // 前回の検索時からクエリが変わっていない場合、ソート順の変更で即座に検索し直すことが期待されていると考え検索を実行する
        // クエリが変わっている場合は次に検索ボタンがタップされるまで検索しない
        if let lastSearchedQuery = lastSearchedQuery, query == lastSearchedQuery {
            search()
        }
    }

    private func onLanguageChanged() {
        // 前回の検索時からクエリが変わっていない場合、言語の変更で即座に検索し直すことが期待されていると考え検索を実行する
        // クエリが変わっている場合は次に検索ボタンがタップされるまで検索しない
        if let lastSearchedQuery = lastSearchedQuery, query == lastSearchedQuery {
            search()
        }
    }

    private func search() {
        task?.cancel()
        task = Task {
            guard !query.isEmpty else { return }

            eventContinuation?.yield(.showLoading)
            do {
                let lang = language == L10n.GitHub.Search.allLanguages ? nil : language
                repositories = try await githubClient.search(
                    query: query, sortOrder: sortOrder, page: 1, language: lang)
                lastSearchedQuery = query
                lastSearchedPage = 1
            } catch {
                logger.warning(
                    "failed to search repository: \(error.userMessage, privacy: .public)")
                eventContinuation?.yield(.showErrorAlert(message: error.userMessage))
            }
            eventContinuation?.yield(.hideLoading)
        }
    }

    private func searchMore() {
        task?.cancel()
        task = Task {
            guard !query.isEmpty else { return }

            do {
                let lang = language == L10n.GitHub.Search.allLanguages ? nil : language
                guard let lastSearchedPage = lastSearchedPage else { return }

                let repos = try await githubClient.search(
                    query: query, sortOrder: sortOrder, page: lastSearchedPage + 1, language: lang)
                repositories = repositories + repos
                lastSearchedQuery = query
                self.lastSearchedPage = lastSearchedPage + 1
            } catch {
                logger.warning(
                    "failed to read more repository: \(error.userMessage, privacy: .public)")
            }
        }
    }

}
