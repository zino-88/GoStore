//
//  ObserveSeenProductsUseCase
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Use case that continuously observes recently seen products.
//  It exposes a Combine publisher stream emitting updates from the repository.
//

import Combine

class ObserveSeenProductsUseCase {
    private let repository: SeenProductRepository
    
    init(repository: SeenProductRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<SeenProductsResult, Never> {
        repository.observeSeenProducts()
    }
}
