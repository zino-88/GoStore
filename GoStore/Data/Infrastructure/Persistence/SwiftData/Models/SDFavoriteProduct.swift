//
//  SDFavoriteProduct
//  Created by Zine.
//
//  SwiftData entity representing a persisted favorite product.
//

import Foundation
import SwiftData

@Model
final class SDFavoriteProduct: Identifiable {
    @Attribute(.unique) var productId: Int
    var createdAt: Date
    
    @Relationship(deleteRule: .nullify)
    var product: SDProduct
    
    init(productModel: SDProduct) {
        self.productId = productModel.id
        self.product = productModel
        self.createdAt = Date()
    }
}
