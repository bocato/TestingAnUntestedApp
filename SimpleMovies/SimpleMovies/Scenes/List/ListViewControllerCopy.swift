//
//  ListViewControllerCopy.swift
//  SimpleMovies
//
//  Created by André Sanches Bocato on 21/09/20.
//  Copyright © 2020 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class ListViewControllerCopy: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var searchResults = [SearchResponse.Result]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        FavoritesManager.shared.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = 200
        tableView.register(
            UINib(nibName: "ListTableViewCell", bundle: Bundle(for: ListTableViewCell.self)),
            forCellReuseIdentifier: "ListTableViewCell"
        )
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        let text = searchTextField.text!
        searchMovieWithTitle(text)
    }
    
    // MARK: - Search Logic
    
    func searchMovieWithTitle(_ title: String) {
        
        let service = MoviesService()
        
        service.searchMovies(withTitle: title) { [unowned self] result in
            switch result {
            case let .success(moviesFromSearch):
                self.handleMoviesSearchSuccess(moviesFromSearch)
            case .failure:
                break
            }
        }
        
    }
    
    private func handleMoviesSearchSuccess(_ results: [SearchResponse.Result]) {
        searchResults = results
        tableView.reloadData()
        tableView.isHidden = searchResults.count == 0
        searchTextField.text = ""
    }
    
    private func handleMoviesServiceError(_ error: MoviesServiceError) {
        switch error {
        case let .api(apiError):
            AlertHelper.presentSimpleAlert(
                from: self,
                title: "API Error",
                message: apiError.error
            )
        default:
            AlertHelper.presentSimpleAlert(
                from: self,
                title: "Error",
                message: "Something is wrong.\nTry again :)"
            )
        }
    }
    
    
}
extension ListViewControllerCopy: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        let searchResult = searchResults[indexPath.row]
        let viewData = buildViewData(
            from: searchResult
        )
        
        cell.setup(
            with: viewData,
            onAddFavoriteTapped: { FavoritesManager.shared.add(searchResult) },
            onRemoveFavoriteTapped: { FavoritesManager.shared.remove(searchResult) }
        )
        
        return cell
        
    }
    
    private func buildViewData(
        from searchResult: SearchResponse.Result
    ) -> ListItemViewData {
        let isFavorite = FavoritesManager.shared.isMarkedAsFavorite(searchResult)
        return ListItemViewData(
            searchResult: searchResult,
            isFavorite: isFavorite
        )
    }
    
}

