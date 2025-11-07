//
//  FSProductRepository
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Implementation of ProductRepository using the FakeStore API.
//  Fetches and maps remote product data into domain models.
//

class FSProductRepository: ProductRepository {
    private let productsAPIClient: FakeStoreAPIClient
    
    init(productsAPIClient: FakeStoreAPIClient = FakeStoreAPIClient()) {
        self.productsAPIClient = productsAPIClient
    }
    
    func fetchProducts() async throws -> [Product] {
        let fsProducts = try await productsAPIClient.getAllProducts()
        return fsProducts.map { $0.toDomain() }
        
    }
    
    func fetchProduct(with id: Int) async throws -> Product {
        let fsProduct =  try await productsAPIClient.getSingleProduct(with: id)
        return fsProduct.toDomain()
    }
}
