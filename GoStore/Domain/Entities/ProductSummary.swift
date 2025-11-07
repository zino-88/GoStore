//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import Foundation

struct ProductSummary: Identifiable {
    let id: Int
    let title: String
    let price: Double
    let imageURL: URL
}

extension ProductSummary: Hashable {
    static func == (lhs: ProductSummary, rhs: ProductSummary) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
