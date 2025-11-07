//
//  SDFavoriteProductRepository
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Implementation of FavoriteProductRepository using SwiftData persistence.
//  Manages local persistence and observation of favorite products.
//

import Foundation
import SwiftData
import Combine

final class SDFavoriteProductRepository: FavoriteProductRepository {
    
    // MARK: - Dependencies
    private let context: ModelContext
    private let productPersistence: SDProductPersistence
    
    // MARK: - Configuration
    private let isObservationEnabled: Bool
    
    // MARK: - Publishers
    private let publisher = CurrentValueSubject<FavoriteProductsResult, Never>(.success([]))
    
    // MARK: - Initialization
    init (context: ModelContext, observationEnabled: Bool = false) {
        self.context = context
        self.productPersistence = SDProductPersistence(context: context)
        self.isObservationEnabled = observationEnabled
        
        if isObservationEnabled {
            refreshPublisher()
        }
    }
    
    // MARK: - FavoriteProductRepository Conformance
  
    func getFavoriteProducts() throws -> [FavoriteProduct] {
        let sdFavoriteProducts = try context.fetch(
            model: SDFavoriteProduct.self,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return sdFavoriteProducts.map { $0.toDomain() }
    }
    
    func addToFavorites(_ product: Product) throws {
        if try isFavorite(product) { return }
        
        let sdProduct = try productPersistence.createOrUpdate(from: product)
        let sdFavoriteProduct = SDFavoriteProduct(productModel: sdProduct)
        context.insert(sdFavoriteProduct)
        try context.save()
        
        if isObservationEnabled {
            refreshPublisher()
        }
    }
    
    func removeFromFavorites(_ product: Product) throws {
        guard try isFavorite(product) else { return }
        
        let productId = product.id
        try context.delete(
            model: SDFavoriteProduct.self,
            where: #Predicate { $0.productId == productId })
        try productPersistence.deleteIfOrphan(productId: product.id)
        try context.save()
        
        if isObservationEnabled {
            refreshPublisher()
        }
    }
    
    func isFavorite(_ product: Product) throws -> Bool {
        let productId = product.id
        return try context.exists(
            model: SDFavoriteProduct.self,
            where: #Predicate { $0.productId == productId }
        )
    }
    
    func observeFavoriteProducts() -> AnyPublisher<FavoriteProductsResult, Never> {
        return publisher.eraseToAnyPublisher()
    }
    
    // MARK: - Internal Helpers
    
    private func refreshPublisher() {
        do {
            let snapshot = try getFavoriteProducts()
            publisher.send(.success(snapshot))
        } catch {
            publisher.send(.failure(error))
        }
    }
}
