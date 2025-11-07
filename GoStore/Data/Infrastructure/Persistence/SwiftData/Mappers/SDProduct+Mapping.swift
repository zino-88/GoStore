//
//  SDProduct+Mapping
//  Created by Zine.
//
//  Maps SDProduct entities to/from Domain ProductSummary.
//

import Foundation

extension SDProduct: DomainMappable {
    typealias DomainEntity = ProductSummary
    
    func toDomain() -> ProductSummary {
        ProductSummary(
            id: self.id,
            title: self.name,
            price: self.price,
            imageURL: self.imageURL
        )
    }
    
    static func fromDomain(_ domain: ProductSummary) -> SDProduct {
        SDProduct(
            id: domain.id,
            name: domain.title,
            price: domain.price,
            imageURL: domain.imageURL
        )
    }
    
    func update(from domain: ProductSummary) {
        name = domain.title
        price = domain.price
        imageURL = domain.imageURL
    }
}
