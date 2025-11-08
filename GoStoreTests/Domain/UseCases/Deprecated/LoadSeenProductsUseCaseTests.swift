//
//  GoStoreTests - Clean Architecture Sample
//  Created by Zine.
//

import XCTest
@testable import GoStore

final class LoadSeenProductsUseCaseTests: XCTestCase {
    
    func testExecute_ReturnsSeenProductFromRepository() throws {
        let expectedSeenProducts = Product.mocks.map { SeenProduct(summary: $0.summary) }
        let mockRepository = SeenProductRepositoryMock()
        mockRepository.getSeenProductsStub = .success(expectedSeenProducts)
        let useCase = LoadSeenProductsUseCase(repository: mockRepository)
        
        let seenProducts = try useCase.execute()
        
        XCTAssertEqual(seenProducts.count, expectedSeenProducts.count)
        XCTAssertEqual(seenProducts, expectedSeenProducts)
    }
    
    func testExecute_PropagatesRepositoryError() {
        let mockRepository = SeenProductRepositoryMock()
        mockRepository.getSeenProductsStub = .failure(DummyError.db)
        let useCase = LoadSeenProductsUseCase(repository: mockRepository)

        do {
            _ = try useCase.execute()
            XCTFail("Should have thrown an error")
        } catch let dummyError as DummyError {
            XCTAssertEqual(dummyError, DummyError.db)
        } catch {
            XCTFail("Should have thrown an DummyError")
        }
    }
}

