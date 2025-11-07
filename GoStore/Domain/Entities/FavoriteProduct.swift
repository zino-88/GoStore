//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import Foundation

struct FavoriteProduct: Identifiable, Hashable {
    var id: Int { summary.id }
    
    let summary: ProductSummary
    let addedAt: Date
    
    init(summary: ProductSummary, addedAt: Date = Date()) {
        self.summary = summary
        self.addedAt = addedAt
    }
}
