//
//  GoStoreTests - Clean Architecture Sample
//  Created by Zine.
//

import Foundation
import Combine
@testable import GoStore

final class FavoriteProductRepositoryMock: FavoriteProductRepository {
    
    // MARK: - Stubs
    var getFavoriteProductsStub: FavoriteProductsResult = .success([])
    var addToFavoriteStub: Result<Void, Error> = .success(())
    var removeFromFavoriteStub: Result<Void, Error> = .success(())
    var isFavoriteStub: Result<Bool, Error> = .success(false)
    private let observeSubject = PassthroughSubject<FavoriteProductsResult, Never>()
    
    
    // MARK: - Spy
    private(set) var getFavoriteProductsCalled = false
    private(set) var addToFavoriteCalled = false
    private(set) var removeFromFavoriteCalled = false
    private(set) var isFavoriteCalled = false
    private(set) var observeFavoriteProductsCalled = false
    
    private(set) var addedProducts: [Product] = []
    private(set) var removedProducts: [Product] = []
    private(set) var checkedProducts: [Product] = []
    
    
    // MARK: - Conformance
    func getFavoriteProducts() throws -> [GoStore.FavoriteProduct] {
        getFavoriteProductsCalled = true
        return try getFavoriteProductsStub.get()
    }
    
    func addToFavorites(_ product: GoStore.Product) throws {
        addToFavoriteCalled = true
        addedProducts.append(product)
        try addToFavoriteStub.get()
    }
    
    func removeFromFavorites(_ product: GoStore.Product) throws {
        removeFromFavoriteCalled = true
        removedProducts.append(product)
        try removeFromFavoriteStub.get()
    }
    
    func isFavorite(_ product: GoStore.Product) throws -> Bool {
        isFavoriteCalled = true
        checkedProducts.append(product)
        return try isFavoriteStub.get()
    }
    
    func observeFavoriteProducts() -> AnyPublisher<GoStore.FavoriteProductsResult, Never> {
        observeFavoriteProductsCalled = true
        return observeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Test helpers
    func sendObserve(_ value: FavoriteProductsResult) {
        observeSubject.send(value)
    }
}
