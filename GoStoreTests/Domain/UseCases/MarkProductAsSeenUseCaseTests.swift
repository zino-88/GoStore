import XCTest
@testable import GoStore


final class MarkProductAsSeenUseCaseTests: XCTestCase {
    
    func testExecute_MarksProductAsSeen() throws {
        let product = Product.mock
        let repositoryMock = SeenProductRepositoryMock()
        let useCase = MarkProductAsSeenUseCase(repository: repositoryMock)
        
        try useCase.execute(with: product)
        
        XCTAssertTrue(repositoryMock.markSeenProductCalled)
        XCTAssertTrue(repositoryMock.markedSeenProducts.contains(product))
    }
    
    func testExecute_PropagatesRepositoryError() {
        let product = Product.mock
        let repositoryMock = SeenProductRepositoryMock()
        repositoryMock.markSeenProductStub = .failure(DummyError.db)
        let useCase = MarkProductAsSeenUseCase(repository: repositoryMock)
        
        do {
            try useCase.execute(with: product)
            XCTFail("Should have thrown an error")
        } catch let dummyError as DummyError  {
            XCTAssertEqual(dummyError, DummyError.db)
        } catch {
            XCTFail("Should have thrown an DummyError")
        }
    }
}
