//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import Foundation

struct SeenProduct: Identifiable, Hashable {
    var id: Int { summary.id }
    
    let summary: ProductSummary
    let lastSeenAt: Date
    
    init(summary: ProductSummary, lastSeenAt: Date = Date()) {
        self.summary = summary
        self.lastSeenAt = lastSeenAt
    }
}
