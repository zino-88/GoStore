//
//  ObserveFavoriteProductsUseCase
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Use case that continuously observes changes to favorite products.
//  It exposes a Combine publisher stream emitting updates from the repository.
//

import Combine

class ObserveFavoriteProductsUseCase {
    private let repository: FavoriteProductRepository
    
    init(repository: FavoriteProductRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<FavoriteProductsResult, Never> {
        repository.observeFavoriteProducts()
    }
}
