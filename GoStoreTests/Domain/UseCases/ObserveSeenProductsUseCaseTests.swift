//
//  GoStoreTests - Clean Architecture Sample
//  Created by Zine.
//

import XCTest
import Combine
@testable import GoStore

final class ObserveSeenProductsUseCaseTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    func testExecute_ReturnsPublisherFromRepository() {
        let initialSeenProducts: [SeenProduct] = [SeenProduct(summary: Product.mock.summary)]
        let finalSeenProducts: [SeenProduct] = Product.mocks.map { SeenProduct(summary: $0.summary) }

        var seenProducts: [SeenProduct] = []
        var seenProductsError: Error?
        
        let mockRepository = SeenProductRepositoryMock()
        let useCase = ObserveSeenProductsUseCase(repository: mockRepository)
        useCase.execute()
            .sink { result in
                switch result {
                case .success(let favorites):
                    seenProducts = favorites
                case .failure(let error):
                    seenProductsError = error
                }
            }
            .store(in: &cancellables)

        mockRepository.sendObserve(.success(initialSeenProducts))
        mockRepository.sendObserve(.success(finalSeenProducts))
        mockRepository.sendObserve(.failure(DummyError.db))

        XCTAssertEqual(seenProducts, finalSeenProducts)
        if let dummyError = seenProductsError as? DummyError {
            XCTAssertEqual(dummyError, DummyError.db)
        } else {
            XCTFail("Should have thrown an DummyError")
        }
    }

}
