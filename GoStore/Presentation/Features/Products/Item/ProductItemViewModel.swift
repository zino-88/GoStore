//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

struct ProductItemViewModel {
    
    // MARK: - UI State
    let product: ProductSummary
    let isFavorite: Bool
    
    // MARK: - Initialization
    init(product: ProductSummary, isFavorite: Bool) {
        self.product = product
        self.isFavorite = isFavorite
    }
}
