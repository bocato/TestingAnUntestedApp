//
//  ListViewController.swift
//  SimpleMovies
//
//  Created by Eduardo Sanches Bocato on 16/02/20.
//  Copyright © 2020 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var searchResults = [SearchResponse.Result]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Setup
    
    func setupTableView() {
        tableView.delegate = self
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
        guard let text = searchTextField.text, !text.isEmpty else {
            AlertHelper.presentOkAlert(
                from: self,
                message: "Empty search field!"
            )
            return
        }
        searchMovieWithTitle(text)
    }
    
    // MARK: - Search Logic
    
    func searchMovieWithTitle(_ title: String) {
        
        let service = MoviesService()
        
        service.searchMovies(withTitle: title) { [unowned self] result in
            switch result {
            case let .success(moviesFromSearch):
                self.handleMoviesSearchSuccess(moviesFromSearch)
            case let .failure(serviceError):
                self.handleMoviesServiceError(serviceError)
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
            AlertHelper.presentOkAlert(
                from: self,
                title: "API Error",
                message: apiError.error
            )
        default:
            AlertHelper.presentOkAlert(
                from: self,
                title: "Error",
                message: "Something is wrong.\nTry again :)"
            )
        }
    }
    
    
}
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        let data = searchResults[indexPath.row]
        cell.setup(data)
        
        return cell
        
    }
    
}
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
