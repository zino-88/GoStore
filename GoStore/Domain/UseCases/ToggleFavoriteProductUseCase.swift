//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

class ToggleFavoriteProductUseCase {
    private let repository: FavoriteProductRepository
    
    init(repository: FavoriteProductRepository) {
        self.repository = repository
    }
    
    func execute(with product: Product) throws {
        if try repository.isFavorite(product) {
            try repository.removeFromFavorites(product)
        } else {
            try repository.addToFavorites(product)
        }
    }
}
