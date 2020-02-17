//
//  ListViewControllerTests.swift
//  SimpleMoviesTests
//
//  Created by Eduardo Sanches Bocato on 17/02/20.
//  Copyright © 2020 Eduardo Sanches Bocato. All rights reserved.
//

import XCTest
@testable import SimpleMovies

final class ListViewControllerTests: XCTestCase {
    
    // Using:
    // - Initializer-based Injection
    // - Spies
    func test_whenViewDidLoad_isCalled_favoritesShouldBeLoaded() {
        // Given
        let favoritesManagerSpy = FavoritesManagerSpy()
        let sut = ListViewController(favoritesManager: favoritesManagerSpy)
        _ = sut.view // trick to "force" load the view
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(favoritesManagerSpy.loadCalled)
    }
    
}

// MARK: - Testing Helpers

final class FavoritesManagerSpy: FavoritesManagerProtocol {
    
    var items: [Favorite] = []
    
    private(set) var loadCalled = false
    func load() {
        loadCalled = true
    }

    private(set) var isMarkedAsFavoriteCalled = false
    private(set) var favoritePassedToIsMarkedAsFavorite: Favorite?
    func isMarkedAsFavorite(_ favorite: Favorite) -> Bool {
        isMarkedAsFavoriteCalled = true
        favoritePassedToIsMarkedAsFavorite = favorite
        return true
    }
    
    private(set) var addCalled = false
    private(set) var favoritePassedToAdd: Favorite?
    @discardableResult
    func add(_ favorite: Favorite) -> Bool {
        addCalled = true
        favoritePassedToAdd = favorite
        return true
    }
    
    private(set) var removeCalled = false
    private(set) var favoritePassedToRemove: Favorite?
    @discardableResult
    func remove(_ favorite: Favorite) -> Bool {
        removeCalled = true
        favoritePassedToRemove = favorite
        return true
    }
    
}
