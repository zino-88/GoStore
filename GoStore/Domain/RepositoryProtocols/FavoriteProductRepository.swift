//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import Combine

typealias FavoriteProductsResult = Result<[FavoriteProduct], Error>

protocol FavoriteProductRepository {
    func getFavoriteProducts() throws -> [FavoriteProduct]
    func addToFavorites(_ product: Product) throws
    func removeFromFavorites(_ product: Product) throws
    func isFavorite(_ product: Product) throws -> Bool
    
    func observeFavoriteProducts() -> AnyPublisher<FavoriteProductsResult, Never>
}
