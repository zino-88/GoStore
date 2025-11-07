//
//  LoadSeenProductsUseCase
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Deprecated use case for loading recently seen products once from the repository.
//  Replaced by ObserveSeenProductsUseCase, which provides continuous observation
//  for changes to recently seen products.
//

class LoadSeenProductsUseCase {
    private let repository: SeenProductRepository
    
    init(repository: SeenProductRepository) {
        self.repository = repository
    }
    
    func execute() throws -> [SeenProduct] {
        try repository.getSeenProducts()
    }
}
