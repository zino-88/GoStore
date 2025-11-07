//
//  SDSeenProduct+Mapping
//  Created by Zine.
//
//  Maps recently viewed SwiftData entities to Domain models.
//

import Foundation

extension SDSeenProduct: DomainConvertible {
    typealias DomainEntity = SeenProduct
    
    func toDomain() -> SeenProduct {
        SeenProduct(
            summary: product.toDomain(),
            lastSeenAt: seenAt
        )
    }
}
