//
//  RepositorySearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositorySearchViewController: UITableViewController {

    @IBOutlet weak private var searchBar: UISearchBar!

    private(set) var repositories: [[String: Any]] = []
    private(set) var selectedIndex: Int!

    private var task: URLSessionTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupSearchBar()
        setupTableView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let detailVC = segue.destination as! RepositoryDetailViewController
            detailVC.repository = repositories[selectedIndex]
        }
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
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selectedIndex は画面遷移先で使われるので遷移前に値を設定しておく必要がある
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
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
        let query = searchBar.text!
        guard !query.isEmpty else { return }

        searchBar.resignFirstResponder()

        let url = "https://api.github.com/search/repositories?q=\(query)"
        task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
            guard let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any],
                let items = obj["items"] as? [[String: Any]]
            else {
                return
            }

            self.repositories = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task?.resume()
    }

}
