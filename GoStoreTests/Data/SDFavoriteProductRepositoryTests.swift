import XCTest
import Combine
import SwiftData
@testable import GoStore

@MainActor
final class SDFavoriteProductRepositoryTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Test AddToFavorites

    func testAddToFavorites_InsertsNewFavorite() throws {
        let context = makeInMemoryContext()
        let repository = SDFavoriteProductRepository(context: context)

        let product = Product.mock
        try repository.addToFavorites(product)

        let isFavorite = try repository.isFavorite(product)
        let favoriteProduct = try XCTUnwrap(try repository.getFavoriteProducts().first)
        XCTAssertTrue(isFavorite)
        XCTAssertEqual(favoriteProduct.id, product.id)
    }

    func testAddToFavorites_DoesNotDuplicateExistingFavorite() throws {
        let context = makeInMemoryContext()
        let repository = SDFavoriteProductRepository(context: context)

        let product = Product.mock
        try repository.addToFavorites(product)
        try repository.addToFavorites(product) // Add same product

        let isFavorite = try repository.isFavorite(product)
        let favoriteProducts = try repository.getFavoriteProducts()
        let favoriteProduct = try XCTUnwrap(favoriteProducts.first)
        XCTAssertEqual(favoriteProducts.count, 1)
        XCTAssertTrue(isFavorite)
        XCTAssertEqual(favoriteProduct.id, product.id)
    }
    
    // MARK: - Test RemoveFromFavorites

    func testRemoveFromFavorites_DeletesFavoriteAndCleansUpOrphanProduct() throws {
        let context = makeInMemoryContext()
        let repository = SDFavoriteProductRepository(context: context)

        let product = Product.mock
        try repository.addToFavorites(product)
        try repository.removeFromFavorites(product)

        let favorites = try repository.getFavoriteProducts()
        XCTAssertTrue(favorites.isEmpty)

        let sdProductCount = try context.fetchCount(model: SDProduct.self)
        XCTAssertEqual(sdProductCount, 0)
    }
    
    func testRemoveFromFavorites_DeletesFavoriteAndKeepsReferencedProduct() throws {
        let context = makeInMemoryContext()
        let favoriteRepository = SDFavoriteProductRepository(context: context)
        let seenRepository = SDSeenProductRepository(context: context)

        let product = Product.mock
        try favoriteRepository.addToFavorites(product)
        try seenRepository.markSeen(product)
        try favoriteRepository.removeFromFavorites(product)

        let favorites = try favoriteRepository.getFavoriteProducts()
        XCTAssertTrue(favorites.isEmpty)

        let sdProductCount = try context.fetchCount(model: SDProduct.self)
        XCTAssertEqual(sdProductCount, 1)
    }
    
    // MARK: - Test IsFavorites

    func testIsFavorite_ReturnsTrueWhenFavorite() throws {
        let context = makeInMemoryContext()
        let repository = SDFavoriteProductRepository(context: context, observationEnabled: false)

        let product = Product.mock
        XCTAssertFalse(try repository.isFavorite(product))
        try repository.addToFavorites(product)
        XCTAssertTrue(try repository.isFavorite(product))
    }
    
    // MARK: - Test GetFavoriteProducts

    func testGetFavoriteProducts_ReturnsProductsSortedByAddedDateDesc() throws {
        let context = makeInMemoryContext()
        let repository = SDFavoriteProductRepository(context: context, observationEnabled: false)

        let product1 = Product.mock1
        let product2 = Product.mock2

        try repository.addToFavorites(product1)
        usleep(10_000) // wait 10ms to prevent same insert date
        try repository.addToFavorites(product2)

        let favoriteIds = try repository.getFavoriteProducts().map{ $0.id }
        XCTAssertEqual(favoriteIds, [product2.id, product1.id])
    }
    
    // MARK: - Test ObserveFavoriteProducts

    func testObserveFavoriteProducts_EmitsInitialAndUpdatedValues() throws {
        let context = makeInMemoryContext()
        let repository = SDFavoriteProductRepository(context: context, observationEnabled: true)
        let product = Product.mock

        var emissions: [FavoriteProductsResult] = []

        repository.observeFavoriteProducts()
            .sink { value in
                emissions.append(value)
            }
            .store(in: &cancellables)

        try repository.addToFavorites(product)
        try repository.removeFromFavorites(product)


        guard emissions.count == 3 else {
            XCTFail("Expected 3 emissions (initial, after add, after remove)")
            return
        }

        if case let .success(initialFavorites) = emissions[0] {
            XCTAssertTrue(initialFavorites.isEmpty)
        } else {
            XCTFail("Initial emission should be .success([])")
        }

        if case let .success(favoritesAfterAdd) = emissions[1] {
            XCTAssertEqual(favoritesAfterAdd.count, 1)
            let addedToFavoritesProduct = try XCTUnwrap(favoritesAfterAdd.first)
            XCTAssertEqual(addedToFavoritesProduct.id, product.id)
        } else {
            XCTFail("Second emission should be .success with one favorite")
        }

        if case let .success(favoritesAfterRemove) = emissions[2] {
            XCTAssertTrue(favoritesAfterRemove.isEmpty)
        } else {
            XCTFail("Third emission should be .success([])")
        }
    }
}
