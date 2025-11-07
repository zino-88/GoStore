//
//  FakeStoreAPIClient
//  Created by Zine.
//
//  A simple API client for https://fakestoreapi.com.
//


import Foundation
import APIClientCore

public final class FakeStoreAPIClient: APIClient {
    public let baseURL: URL = URL(string: "https://fakestoreapi.com")!
    
    public func getAllProducts() async throws -> [FSProduct] {
        return try await request(FakeStoreProductsEndpoint.list)
    }

    public func add(_ newProduct: FSProduct) async throws -> FSProduct {
        return try await request(FakeStoreProductsEndpoint.create(newProduct))
    }

    public func getSingleProduct(with productId: Int) async throws -> FSProduct {
        return try await request(FakeStoreProductsEndpoint.item(productId))
    }
    
    public func update(product: FSProduct) async throws -> FSProduct {
        return try await request(FakeStoreProductsEndpoint.update(product))
    }
    
    public func delete(with productId: Int) async throws -> HTTPURLResponse {
        let (_, response) = try await requestData(from: FakeStoreProductsEndpoint.delete(productId))
        return response
    }
}

