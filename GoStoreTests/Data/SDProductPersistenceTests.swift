//
//  GoStoreTests - Clean Architecture Sample
//  Created by Zine.
//

import XCTest
import SwiftData
@testable import GoStore

@MainActor
final class SDProductPersistenceTests: XCTestCase {
    
    // MARK: - Helpers
    
    private func fetchSDProduct(_ context: ModelContext, id: Int) throws -> SDProduct? {
        try context.fetchOne(model: SDProduct.self, where: #Predicate { $0.id == id })
    }
    
    // MARK: - Test CreateOrUpdate
    
    func testCreateOrUpdate_InsertsNewProduct() throws {
        let context = makeInMemoryContext()
        let persistence = SDProductPersistence(context: context)
        
        let product = Product.mock
        
        let _ = try persistence.createOrUpdate(from: product)
        let countAfterInsert = try context.fetchCount(model: SDProduct.self)
        XCTAssertEqual(countAfterInsert, 1)
    }
    
    func testCreateOrUpdate_UpdatesExistingProduct() throws {
        let context = makeInMemoryContext()
        let persistence = SDProductPersistence(context: context)
        
        let product = Product.mock
        let updatedProduct = Product(
            id: product.id,
            title: product.title,
            price: product.price * 1.10, // Increase price by 10%
            description: product.description,
            category: product.category,
            imageURL: product.imageURL,
            rating: product.rating)
        
        let sdProduct1 = try persistence.createOrUpdate(from: product)
        let sdProduct2 = try persistence.createOrUpdate(from: updatedProduct)
        let count = try context.fetchCount(model: SDProduct.self)
        
        XCTAssertEqual(count, 1)
        XCTAssertEqual(sdProduct1.id, sdProduct2.id)
        XCTAssertEqual(sdProduct2.price, updatedProduct.price)
    }
    
    // MARK: - Test DeleteIfOrphan
    
    func testDeleteIfOrphan_DeletesProductWithoutReferences() throws {
        let context = makeInMemoryContext()
        let persistence = SDProductPersistence(context: context)
        
        let product = Product.mock
        _ = try persistence.createOrUpdate(from: product)
        
        XCTAssertNotNil(try fetchSDProduct(context, id: product.id))
        
        try persistence.deleteIfOrphan(productId: product.id)
        
        let remaining = try context.fetchCount(model: SDProduct.self)
        XCTAssertEqual(remaining, 0)
    }
    
    func testDeleteIfOrphan_KeepsProductWithFavoriteReference() throws {
        let context = makeInMemoryContext()
        let persistence = SDProductPersistence(context: context)
        
        let product = Product.mock
        let sdProduct = try persistence.createOrUpdate(from: product)
        
        let favoriteProduct = SDFavoriteProduct(productModel: sdProduct)
        context.insert(favoriteProduct)
        try context.save()
        
        try persistence.deleteIfOrphan(productId: product.id)
        
        let stillThere = try fetchSDProduct(context, id: product.id)
        XCTAssertNotNil(stillThere)
    }
    
    func testDeleteIfOrphan_KeepsProductWithSeenReference() throws {
        let context = makeInMemoryContext()
        let persistence = SDProductPersistence(context: context)
        
        let product = Product.mock
        let sdProduct = try persistence.createOrUpdate(from: product)
        
        let seenProduct = SDSeenProduct(productModel: sdProduct)
        context.insert(seenProduct)
        try context.save()
        
        try persistence.deleteIfOrphan(productId: product.id)
        
        let stillThere = try fetchSDProduct(context, id: product.id)
        XCTAssertNotNil(stillThere)
    }
    
    // MARK: - Test CleanupOrphans
    
    func testCleanupOrphans_RemovesOnlyOrphansAndKeepsReferencedProducts() throws {
        let context = makeInMemoryContext()
        let persistence = SDProductPersistence(context: context)
        
        let orphan = try persistence.createOrUpdate(from: Product.mock1)
        let referenced = try persistence.createOrUpdate(from: Product.mock2)
        context.insert(SDFavoriteProduct(productModel: referenced))
        try context.save()
        
        XCTAssertEqual(try context.fetchCount(model: SDProduct.self), 2)
        
        try persistence.cleanupOrphans()
        
        let countAfter = try context.fetchCount(model: SDProduct.self)
        XCTAssertEqual(countAfter, 1)
        
        let remaining = try XCTUnwrap(try context.fetchOne(model: SDProduct.self))
        XCTAssertEqual(remaining.id, referenced.id)
        XCTAssertNil(try fetchSDProduct(context, id: orphan.id))
    }
     
}

