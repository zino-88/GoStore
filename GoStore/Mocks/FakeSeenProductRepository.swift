//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

#if DEBUG

import Combine

final class FakeSeenProductRepository: SeenProductRepository {
    
    func getSeenProducts() throws -> [SeenProduct] {
        Product.mocks.map {
            SeenProduct(summary: $0.summary)
        }
    }
    
    func markSeen(_ product: Product) throws {}
    
    func clearHistory() throws {}
    
    func isSeen(_ product: Product) throws -> Bool {
        return false
    }
    
    func observeSeenProducts() -> AnyPublisher<Result<[SeenProduct], any Error>, Never> {
        CurrentValueSubject<SeenProductsResult, Never>(
            .success(try! getSeenProducts())
        )
        .eraseToAnyPublisher()
    }
}

#endif
