//
//  ProductsRepositoryMock.swift
//  GoStore
//
//  Created by zine on 03/10/2025.
//

import Foundation
@testable import GoStore

final class ProductRepositoryMock: ProductRepository {
    
    // MARK: - Stubs
    var fetchProductsStub: Result<[Product], Error> = .success([])
    var fetchProductDetailStub: Result<Product, Error> = .failure(DummyError.network)
    
    // MARK: - Spy
    var fetchProductsCalled = false
    var fetchProductDetailCalled = false
    
    // MARK: - Conformance
    func fetchProducts() async throws -> [Product] {
        fetchProductsCalled = true
        return try fetchProductsStub.get()
    }
    
    func fetchProduct(with id: Int) async throws -> Product {
        fetchProductDetailCalled = true
        return try fetchProductDetailStub.get()
    }
}
