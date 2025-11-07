//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

protocol ProductRepository {
    func fetchProducts() async throws -> [Product]
    func fetchProduct(with id: Int) async throws -> Product
}
