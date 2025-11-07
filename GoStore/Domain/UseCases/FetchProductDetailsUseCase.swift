//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

class FetchProductDetailsUseCase {
    private let repository: ProductRepository
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
    
    func execute(with productId: Int) async throws -> Product {
        return try await repository.fetchProduct(with: productId)
    }
}


