//
//  FavoritesManager.swift
//  SimpleMovies
//
//  Created by Eduardo Sanches Bocato on 16/02/20.
//  Copyright © 2020 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

typealias Favorite = SearchResponse.Result

final class FavoritesManager {
    
    // MARK: - Singleton
    
    static let shared = FavoritesManager()
    
    // MARK: - Properties
    
    private(set) var items = [Favorite]()
    
    // MARK: - Public Methods
    
    func load() {
        let defaults = UserDefaults.standard
        guard
            let data = defaults.value(forKey: Constants.favoritesKey) as? Data,
            let decodedData = try? JSONDecoder().decode([Favorite].self, from: data)
        else { return }
        items = decodedData
    }
    
    func add(_ favorite: Favorite) {
        items.append(favorite)
        syncronize()
    }
    
    func remove(_ favorite: Favorite) {
        guard let index = items.firstIndex(where: { $0.imdbID == favorite.imdbID } ) else { return }
        items.remove(at: index)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Private Properties
    
    private func syncronize() {
        guard let encodedData = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(encodedData, forKey: Constants.favoritesKey)
        UserDefaults.standard.synchronize()
    }
    
}
