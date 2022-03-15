//
//  RepositorySearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import GitHub
import UIKit

class RepositorySearchViewController: UITableViewController {

    @IBOutlet weak private var searchBar: UISearchBar!

    private var cancellables: [AnyCancellable] = []

    private let viewModel = RepositorySearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupSearchBar()
        setupTableView()
        subscribe()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositoriesCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! SubtitleTableViewCell
        guard let repository = viewModel.repository(index: indexPath.row) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repository = viewModel.repository(index: indexPath.row) else {
            return
        }
        let detailVC = StoryboardScene.RepositoryDetail.initialScene.instantiate { coder in
            let viewModel = RepositoryDetailViewModel(repository: repository)
            return RepositoryDetailViewController(coder: coder, viewModel: viewModel)
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

    private func subscribe() {
        viewModel.events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }

                switch event {
                case .unfocusFromSearchBar:
                    self.searchBar.resignFirstResponder()
                case .reloadData:
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }

}

extension RepositorySearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.onSearchTextChanged()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.onSearchButtonTapped(query: searchBar.text ?? "")
    }

}
