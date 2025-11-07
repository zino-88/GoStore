//
//  LoadFavoriteProductsUseCase
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Deprecated use case for loading favorite products once from the repository.
//  Replaced by ObserveFavoriteProductsUseCase, which provides continuous observation
//  for changes to favorite products.
//

class LoadFavoriteProductsUseCase {
    private let repository: FavoriteProductRepository
    
    init(repository: FavoriteProductRepository) {
        self.repository = repository
    }
    
    func execute() throws -> [FavoriteProduct] {
        return try repository.getFavoriteProducts()
    }
}
