//
//  SDSeenProduct
//  Created by Zine.
//
//  SwiftData entity representing a recently viewed product.
//

import Foundation
import SwiftData

@Model
final class SDSeenProduct: Identifiable {
    @Attribute(.unique) var productId: Int
    var seenAt: Date
    
    @Relationship(deleteRule: .nullify)
    var product: SDProduct
    
    init(productModel: SDProduct) {
        self.productId = productModel.id
        self.product = productModel
        self.seenAt = Date()
    }
}
