//
//  FSProduct+Mapping
//  Created by Zine.
//
//  Maps infrastructure models (FakeStore) to Domain entities.
//

extension FSProduct: DomainConvertible {
    typealias DomainEntity = Product
    
    func toDomain() -> Product {
        Product(
            id: id,
            title: title,
            price: price,
            description: description,
            category: category,
            imageURL: image,
            rating: Rating(rate: rating.rate, count: rating.count)
        )
    }
}
