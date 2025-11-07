//
//  SDSeenProductRepository
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Implementation of SeenProductRepository using SwiftData persistence.
//  Manages local persistence and observation of recently seen products.

import Foundation
import SwiftData
import Combine

final class SDSeenProductRepository: SeenProductRepository {
    
    // MARK: - Dependencies
    private let context: ModelContext
    private let productPersistence: SDProductPersistence
    
    // MARK: - Configuration
    private let isObservationEnabled: Bool
    
    // MARK: - Publishers
    private let publisher = CurrentValueSubject<SeenProductsResult, Never>(.success([]))
    
    init (context: ModelContext, observationEnabled: Bool = false) {
        self.context = context
        self.productPersistence = SDProductPersistence(context: context)
        self.isObservationEnabled = observationEnabled
        
        if isObservationEnabled {
            refreshPublisher()
        }
    }
    
    // MARK: - SeenProductRepository Conformance
    
    func getSeenProducts() throws -> [SeenProduct] {
        let sdSeenProducts = try context.fetch(
            model: SDSeenProduct.self,
            sortBy: [SortDescriptor(\.seenAt, order: .reverse)]
        )
        return sdSeenProducts.map { $0.toDomain() }
    }
    
    func markSeen(_ product: Product) throws {
        let sdSeenProduct = try productPersistence.createOrUpdate(from: product)
        try createOrUpdateSeenProductModel(with: sdSeenProduct)
        try context.save()
        
        if isObservationEnabled {
            refreshPublisher()
        }
    }
    
    func isSeen(_ product: Product) throws -> Bool {
        let productId = product.id
        return try context.exists(
            model: SDSeenProduct.self,
            where: #Predicate { $0.productId == productId }
        )
    }
    
    func clearHistory() throws {
        try context.delete(model: SDSeenProduct.self)
        try productPersistence.cleanupOrphans()
        try context.save()
        
        if isObservationEnabled {
            refreshPublisher()
        }
    }
    
    func observeSeenProducts() -> AnyPublisher<SeenProductsResult, Never> {
        return publisher.eraseToAnyPublisher()
    }
    
    // MARK: - Internal Helpers
    
    private func createOrUpdateSeenProductModel(with productModel: SDProduct) throws {
        let id = productModel.id
        if let sdSeenProduct = try context.fetchOne(
            model: SDSeenProduct.self,
            where: #Predicate { $0.productId == id }
        ) {
            sdSeenProduct.seenAt = Date()
        } else {
            let newSDSeenProduct = SDSeenProduct(productModel: productModel)
            context.insert(newSDSeenProduct)
        }
    }
    
    private func refreshPublisher() {
        do {
            let snapshot = try getSeenProducts()
            publisher.send(.success(snapshot))
        } catch {
            publisher.send(.failure(error))
        }
    }
    
}
