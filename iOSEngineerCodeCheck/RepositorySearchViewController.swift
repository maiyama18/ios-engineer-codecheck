//
//  RepositorySearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import GitHub
import UIKit

class RepositorySearchViewController: UITableViewController {

    @IBOutlet weak private var searchBar: UISearchBar!

    private(set) var repositories: [Repository] = []

    private var task: Task<Void, Never>?

    private let githubClient: GitHubClientProtocol = GitHubClient.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupSearchBar()
        setupTableView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! SubtitleTableViewCell
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = repositories[indexPath.row]
        let detailVC = StoryboardScene.RepositoryDetail.initialScene.instantiate { coder in
            RepositoryDetailViewController(coder: coder, repository: repository)
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func setupNavigationBar() {
        title = "Search Repositories"
    }

    private func setupSearchBar() {
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
    }

    private func setupTableView() {
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

extension RepositorySearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        task = Task {
            do {
                repositories = try await githubClient.search(query: searchBar.text ?? "")
                await MainActor.run {
                    self.tableView.reloadData()
                }
            } catch {
                // TODO: エラーハンドリング
            }
        }
    }

}
