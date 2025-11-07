//
//  SDFavoriteProduct+Mapping
//  Created by Zine.
//
//  Maps SwiftData favorite product entities to Domain models.
//

import Foundation

extension SDFavoriteProduct: DomainConvertible {
    typealias DomainEntity = FavoriteProduct
    
    func toDomain() -> FavoriteProduct {
        FavoriteProduct(
            summary: product.toDomain(),
            addedAt: createdAt
        )
    }
}
