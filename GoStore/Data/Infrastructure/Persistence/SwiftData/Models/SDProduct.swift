//
//  SDProduct
//  Created by Zine.
//
//  SwiftData entity representing a persisted product.
//

import Foundation
import SwiftData

@Model
final class SDProduct: Identifiable {
    @Attribute(.unique) var id: Int
    var name: String
    var price: Double
    var imageURL: URL

    @Relationship(deleteRule: .cascade, inverse: \SDFavoriteProduct.product)
    var favorite: SDFavoriteProduct?
    
    @Relationship(deleteRule: .cascade, inverse: \SDSeenProduct.product)
    var seen: SDSeenProduct?
    
    init(id: Int, name: String, price: Double, imageURL: URL) {
        self.id = id
        self.name = name
        self.price = price
        self.imageURL = imageURL
    }
}
