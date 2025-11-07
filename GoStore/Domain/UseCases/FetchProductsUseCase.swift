//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

class FetchProductsUseCase {
    private let repository: ProductRepository
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [Product] {
        return try await repository.fetchProducts()
    }
}
