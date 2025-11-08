//
//  GoStoreTests - Clean Architecture Sample
//  Created by Zine.
//

import XCTest
import Combine
import SwiftData
@testable import GoStore

@MainActor
final class SDSeenProductRepositoryTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
        
    // MARK: - Test MarkSeen
    
    func testMarkSeen_InsertsNewSeen() throws {
        let context = makeInMemoryContext()
        let repository = SDSeenProductRepository(context: context)
        
        let product = Product.mock
        try repository.markSeen(product)
        
        let isSeen = try repository.isSeen(product)
        let seenProduct = try XCTUnwrap(try repository.getSeenProducts().first)
        XCTAssertTrue(isSeen)
        XCTAssertEqual(seenProduct.id, product.id)
    }
    
    func testMarkSeen_DoesNotDuplicateExistingSeen() throws {
        let context = makeInMemoryContext()
        let repository = SDSeenProductRepository(context: context)
        
        let product = Product.mock
        try repository.markSeen(product)
        try repository.markSeen(product) // idempotent
        
        let isSeen = try repository.isSeen(product)
        let seen = try repository.getSeenProducts()
        let first = try XCTUnwrap(seen.first)
        XCTAssertEqual(seen.count, 1)
        XCTAssertTrue(isSeen)
        XCTAssertEqual(first.id, product.id)
    }
    
    func testMarkSeen_UpdatesSeenDateWhenAlreadySeen() throws {
        let context = makeInMemoryContext()
        let repository = SDSeenProductRepository(context: context)
        let product = Product.mock
        
        try repository.markSeen(product)
        let firstSeen = try XCTUnwrap(try repository.getSeenProducts().first)
        let initialDate = firstSeen.lastSeenAt
        usleep(10_000) // wait 10ms to prevent same update date
        try repository.markSeen(product)
        let updatedSeen = try XCTUnwrap(try repository.getSeenProducts().first)
        let updatedDate = updatedSeen.lastSeenAt

        XCTAssertEqual(firstSeen.id, updatedSeen.id)
        XCTAssertTrue(updatedDate > initialDate)
    }
    
    // MARK: - Test IsSeen
    
    func testIsSeen_ReturnsTrueWhenSeen() throws {
        let context = makeInMemoryContext()
        let repository = SDSeenProductRepository(context: context, observationEnabled: false)
        
        let product = Product.mock
        XCTAssertFalse(try repository.isSeen(product))
        try repository.markSeen(product)
        XCTAssertTrue(try repository.isSeen(product))
    }
    
    // MARK: - Test GetSeenProducts
    
    func testGetSeenProducts_ReturnsProductsSortedByLastSeenDateDesc() throws {
        let context = makeInMemoryContext()
        let repository = SDSeenProductRepository(context: context, observationEnabled: false)
        
        let product1 = Product.mock1
        let product2 = Product.mock2
        
        try repository.markSeen(product1)
        usleep(10_000) // wait 10ms to prevent same insert date
        try repository.markSeen(product2)
        
        let seenIds = try repository.getSeenProducts().map { $0.id }
        XCTAssertEqual(seenIds, [product2.id, product1.id])
    }
    
    // MARK: - Test ClearHistory
    
    func testClearHistory_DeletesAllAndCleansUpOrphanProducts() throws {
        let context = makeInMemoryContext()
        let repository = SDSeenProductRepository(context: context)
        
        let product1 = Product.mock1
        let product2 = Product.mock2
        try repository.markSeen(product1)
        try repository.markSeen(product2)
        
        try repository.clearHistory()
        
        let seen = try repository.getSeenProducts()
        XCTAssertTrue(seen.isEmpty)
        
        let sdProductCount = try context.fetchCount(model: SDProduct.self)
        XCTAssertEqual(sdProductCount, 0)
    }
    
    func testClearHistory_KeepsProductsReferencedByFavorite() throws {
        let context = makeInMemoryContext()
        let seenRepository = SDSeenProductRepository(context: context)
        let favoriteRepository = SDFavoriteProductRepository(context: context)
        
        let product = Product.mock
        try seenRepository.markSeen(product)
        try favoriteRepository.addToFavorites(product)
        
        try seenRepository.clearHistory()
        
        let seen = try seenRepository.getSeenProducts()
        XCTAssertTrue(seen.isEmpty)
        
        let sdProductCount = try context.fetchCount(model: SDProduct.self)
        XCTAssertEqual(sdProductCount, 1)
    }
    
    // MARK: - Test ObserveSeenProducts
    
    func testObserveSeenProducts_EmitsInitialAndUpdatedValues() throws {
        let context = makeInMemoryContext()
        let repository = SDSeenProductRepository(context: context, observationEnabled: true)
        let product = Product.mock
        
        var emissions: [SeenProductsResult] = []
        
        repository.observeSeenProducts()
            .sink { value in
                emissions.append(value)
            }
            .store(in: &cancellables)
        
        try repository.markSeen(product)
        try repository.clearHistory()
        
        guard emissions.count == 3 else {
            XCTFail("Expected 3 emissions (initial, after markSeen, after clearHistory)")
            return
        }
        
        if case let .success(initialSeenProducts) = emissions[0] {
            XCTAssertTrue(initialSeenProducts.isEmpty)
        } else {
            XCTFail("Initial emission should be .success([])")
        }
        
        if case let .success(seenProductsAfterMark) = emissions[1] {
            XCTAssertEqual(seenProductsAfterMark.count, 1)
            let seenProduct = try XCTUnwrap(seenProductsAfterMark.first)
            XCTAssertEqual(seenProduct.id, product.id)
        } else {
            XCTFail("Second emission should be .success with one seen product")
        }
        
        if case let .success(seenProductsAfterClear) = emissions[2] {
            XCTAssertTrue(seenProductsAfterClear.isEmpty)
        } else {
            XCTFail("Third emission should be .success([])")
        }
    }
}
