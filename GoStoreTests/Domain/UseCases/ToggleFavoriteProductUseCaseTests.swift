//
//  GoStoreTests - Clean Architecture Sample
//  Created by Zine.
//

import XCTest
@testable import GoStore

final class ToggleFavoriteProductUseCaseTests: XCTestCase {
    
    func testExecute_WhenNotFavorite() throws {
        let product = Product.mock
        let mockRepository = FavoriteProductRepositoryMock()
        mockRepository.isFavoriteStub = .success(false)
        let useCase = ToggleFavoriteProductUseCase(repository: mockRepository)

        try useCase.execute(with: product)

        XCTAssertTrue(mockRepository.isFavoriteCalled)
        XCTAssertTrue(mockRepository.addToFavoriteCalled)
        XCTAssertFalse(mockRepository.removeFromFavoriteCalled)
        XCTAssertTrue(mockRepository.addedProducts.contains(product))
    }

    func testExecute_WhenAlreadyFavorite() throws {
        let product = Product.mock
        let mockRepository = FavoriteProductRepositoryMock()
        mockRepository.isFavoriteStub = .success(true)
        let useCase = ToggleFavoriteProductUseCase(repository: mockRepository)

        try useCase.execute(with: product)

        XCTAssertTrue(mockRepository.isFavoriteCalled)
        XCTAssertFalse(mockRepository.addToFavoriteCalled)
        XCTAssertTrue(mockRepository.removeFromFavoriteCalled)
        XCTAssertTrue(mockRepository.removedProducts.contains(product))
    }
    
    func testExecute_PropagatesRepositoryCheckError() {
        let product = Product.mock
        let mockRepository = FavoriteProductRepositoryMock()
        mockRepository.isFavoriteStub = .failure(DummyError.db)
        let useCase = ToggleFavoriteProductUseCase(repository: mockRepository)
        
        do {
            _ = try useCase.execute(with: product)
            XCTFail("Should have thrown an error")
        } catch let dummyError as DummyError  {
            XCTAssertEqual(dummyError, DummyError.db)
        } catch {
            XCTFail("Should have thrown an DummyError")
        }
        
        XCTAssertTrue(mockRepository.isFavoriteCalled)
        XCTAssertFalse(mockRepository.addToFavoriteCalled)
        XCTAssertFalse(mockRepository.removeFromFavoriteCalled)
    }
    
    func testExecute_PropagatesRepositoryAddError() {
        let product = Product.mock
        let mockRepository = FavoriteProductRepositoryMock()
        mockRepository.isFavoriteStub = .success(false)
        mockRepository.addToFavoriteStub = .failure(DummyError.db)
        let useCase = ToggleFavoriteProductUseCase(repository: mockRepository)
        
        do {
            _ = try useCase.execute(with: product)
            XCTFail("Should have thrown an error")
        } catch let dummyError as DummyError  {
            XCTAssertEqual(dummyError, DummyError.db)
        } catch {
            XCTFail("Should have thrown an DummyError")
        }
        
        XCTAssertTrue(mockRepository.isFavoriteCalled)
        XCTAssertTrue(mockRepository.addToFavoriteCalled)
        XCTAssertFalse(mockRepository.removeFromFavoriteCalled)
    }
    
    func testExecute_PropagatesRepositoryRemoveError() {
        let product = Product.mock
        let mockRepository = FavoriteProductRepositoryMock()
        mockRepository.isFavoriteStub = .success(true)
        mockRepository.removeFromFavoriteStub = .failure(DummyError.db)
        let useCase = ToggleFavoriteProductUseCase(repository: mockRepository)
        
        do {
            _ = try useCase.execute(with: product)
            XCTFail("Should have thrown an error")
        } catch let dummyError as DummyError  {
            XCTAssertEqual(dummyError, DummyError.db)
        } catch {
            XCTFail("Should have thrown an DummyError")
        }
        
        XCTAssertTrue(mockRepository.isFavoriteCalled)
        XCTAssertFalse(mockRepository.addToFavoriteCalled)
        XCTAssertTrue(mockRepository.removeFromFavoriteCalled)
    }
}
