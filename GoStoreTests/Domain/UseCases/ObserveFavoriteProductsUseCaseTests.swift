//
//  GoStoreTests - Clean Architecture Sample
//  Created by Zine.
//

import XCTest
import Combine
@testable import GoStore

final class ObserveFavoriteProductsUseCaseTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    func testExecute_ReturnsPublisherFromRepository() {
        let initialFavoriteProducts: [FavoriteProduct] = [FavoriteProduct(summary: Product.mock.summary)]
        let finalFavoriteProducts: [FavoriteProduct] = Product.mocks.map { FavoriteProduct(summary: $0.summary) }

        var favoriteProducts: [FavoriteProduct] = []
        var favoriteProductsError: Error?
        
        let mockRepository = FavoriteProductRepositoryMock()
        let useCase = ObserveFavoriteProductsUseCase(repository: mockRepository)
        useCase.execute()
            .sink { result in
                switch result {
                case .success(let favorites):
                    favoriteProducts = favorites
                case .failure(let error):
                    favoriteProductsError = error
                }
            }
            .store(in: &cancellables)

        mockRepository.sendObserve(.success(initialFavoriteProducts))
        mockRepository.sendObserve(.success(finalFavoriteProducts))
        mockRepository.sendObserve(.failure(DummyError.db))

        XCTAssertEqual(favoriteProducts, finalFavoriteProducts)
        if let dummyError = favoriteProductsError as? DummyError {
            XCTAssertEqual(dummyError, DummyError.db)
        } else {
            XCTFail("Should have thrown an DummyError")
        }
    }

}
