//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

#if DEBUG

final class FakeProductRepository: ProductRepository {
    func fetchProduct(with id: Int) async throws -> Product {
        Product.mock
    }
    
    func fetchProducts() async throws -> [Product] {
        return Product.mocks
    }
}

#endif
