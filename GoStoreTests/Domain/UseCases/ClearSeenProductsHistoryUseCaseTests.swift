//
//  GoStoreTests - Clean Architecture Sample
//  Created by Zine.
//

import XCTest
@testable import GoStore

final class ClearSeenProductsHistoryUseCaseTests: XCTestCase {
    
    func testExecute_CallsClearHistoryOnRepository() throws {
        let repositoryMock = SeenProductRepositoryMock()
        let useCase = ClearSeenProductsHistoryUseCase(repository: repositoryMock)
        try useCase.execute()
        
        XCTAssertTrue(repositoryMock.clearHistoryCalled)
    }
    
    func testExecute_ClearsHistoryOnRepository() throws {
        let repositoryMock = SeenProductRepositoryMock()
        try repositoryMock.markSeen(Product.mock1)
        try repositoryMock.markSeen(Product.mock2)
        
        let useCase = ClearSeenProductsHistoryUseCase(repository: repositoryMock)
        try useCase.execute()
        
        XCTAssertTrue(repositoryMock.clearHistoryCalled)
        XCTAssertTrue(repositoryMock.markedSeenProducts.isEmpty)
    }
    
    func testExecute_PropagatesRepositoryError() {
        let repositoryMock = SeenProductRepositoryMock()
        repositoryMock.clearHistoryStub = .failure(DummyError.db)
        
        let useCase = ClearSeenProductsHistoryUseCase(repository: repositoryMock)
        
        do {
            try useCase.execute()
            XCTFail("Should have thrown an error")
        } catch let dummyError as DummyError {
            XCTAssertEqual(dummyError, DummyError.db)
        } catch {
            XCTFail("Should have thrown an DummyError")
        }
    }
    
}
