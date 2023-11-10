//
//  ViewController.swift
//  App Investment
//
//  Created by Chondro Satrio Wibowo on 10/11/23.
//

import UIKit
import Combine
import MBProgressHUD

class SearchTableViewController: UITableViewController, UIAnimatable {
    
    private enum Mode {
        case onboarding
        case search
    }
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()
    
    private let apiService = ApiService()
    private var subscribers = Set<AnyCancellable>()
    @Published private var searchQuery = String()
    @Published private var mode: Mode = .onboarding
    private var searchResults: SearchResults?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        observeForm()
        // Do any additional setup after loading the view.
    }
    
    private func performSearch(searchQuery:String){
        self.showLoadingAnimation()
        apiService.fetchSumbolsPublisher(keywords: searchQuery)
            .sink{ (completion) in
                self.hideLoadingAnimation()
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: break
                }
            } receiveValue: { searchResults in
                self.searchResults = searchResults
                self.tableView.reloadData()
            }.store(in: &self.subscribers)
        }
    
    private func observeForm(){
        $searchQuery.debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink{ [unowned self] (searchQuery) in
                self.performSearch(searchQuery: searchQuery)
            }
            .store(in: &subscribers)
        $mode.sink{ [unowned self] (mode) in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .search:
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    
    
    private func setupNavigationBar(){
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.bestMatches.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
        if let result = searchResults {
            let searchResult = result.bestMatches[indexPath.row]
            cell.configure(with: searchResult)
        }
        return cell
    }

}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
        self.searchQuery = searchQuery
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
}

