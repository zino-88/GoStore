//
//  SDProductPersistence
//  Created by Zine.
//
//  Persistence manager for SDProduct entities using SwiftData.
//

import Foundation
import SwiftData

final class SDProductPersistence {
    private let context: ModelContext
    
    init (context: ModelContext) {
        self.context = context
    }
    
    func createOrUpdate(from product: Product) throws -> SDProduct {
        if let sdProduct = try fetchProductById(byId: product.id) {
            sdProduct.update(from: product.summary)
            return sdProduct
        }
        
        let newSDProduct = SDProduct.fromDomain(product.summary)
        context.insert(newSDProduct)
        return newSDProduct
    }
    
    
    func deleteIfOrphan(productId: Int) throws {
        guard let sdProduct = try fetchProductById(byId: productId) else {
            return
        }
        
        let hasReferences = sdProduct.favorite != nil || sdProduct.seen != nil

        if !hasReferences {
            context.delete(sdProduct)
        }
    }
    
    func cleanupOrphans() throws {
        let predicate = #Predicate<SDProduct> { $0.favorite == nil && $0.seen == nil }
        try context.delete(model: SDProduct.self, where: predicate)
    }
    
    // MARK: - Internal Helpers
    
    private  func fetchProductById(byId productId: Int) throws -> SDProduct? {
        try context.fetchOne(model: SDProduct.self, where: #Predicate { $0.id == productId })
    }
}
