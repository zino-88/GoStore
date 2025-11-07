//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

#if DEBUG
import Combine

final class FakeFavoriteProductRepository: FavoriteProductRepository {
    
    func getFavoriteProducts() throws -> [FavoriteProduct] {
        return [
            FavoriteProduct(
                summary: Product.mock.summary
            )
        ]
    }
    
    func addToFavorites(_ product: Product) throws {}
    
    func removeFromFavorites(_ product: Product) throws {}
    
    func isFavorite(_ product: Product) throws -> Bool {
        return false
    }
    
    func observeFavoriteProducts() -> AnyPublisher<FavoriteProductsResult, Never> {
        CurrentValueSubject<FavoriteProductsResult, Never>(
            .success(try! getFavoriteProducts())
        )
        .eraseToAnyPublisher()
    }
    
}

#endif
