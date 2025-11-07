import XCTest
@testable import GoStore

final class LoadFavoriteProductsUseCaseTests: XCTestCase {
    
    func testExecute_ReturnsFavoriteProductFromRepository() throws {
        let expectedFavorites = Product.mocks.map { FavoriteProduct(summary: $0.summary) }
        let mockRepository = FavoriteProductRepositoryMock()
        mockRepository.getFavoriteProductsStub = .success(expectedFavorites)
        let useCase = LoadFavoriteProductsUseCase(repository: mockRepository)
        
        let favoriteProducts = try useCase.execute()
        
        XCTAssertEqual(favoriteProducts.count, expectedFavorites.count)
        XCTAssertEqual(favoriteProducts.map(\.id), expectedFavorites.map(\.id))
    }
    
    func testExecute_PropagatesRepositoryError() {
        let mockRepository = FavoriteProductRepositoryMock()
        mockRepository.getFavoriteProductsStub = .failure(DummyError.db)
        let useCase = LoadFavoriteProductsUseCase(repository: mockRepository)

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
