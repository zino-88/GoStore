//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import Foundation

struct Product: Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let imageURL: URL
    let rating: Rating
}

extension Product: Hashable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Product {
    var summary: ProductSummary {
        .init(
            id: id,
            title: title,
            price: price,
            imageURL: imageURL
        )
    }
}
