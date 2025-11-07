//
//  FetchProductDetailsUseCaseTests.swift
//  GoStore
//
//  Created by zine on 04/10/2025.
//

import XCTest
@testable import GoStore

final class FetchProductDetailsUseCaseTests: XCTestCase {
    
    func testExecute_ReturnsProductFromRepository() async throws {
        let expectedProduct = Product.mock
        let productId = expectedProduct.id
        let mockRepository = ProductRepositoryMock()
        mockRepository.fetchProductDetailStub = .success(expectedProduct)
        let useCase = FetchProductDetailsUseCase(repository: mockRepository)
        
        let product = try await useCase.execute(with: productId)
        
        XCTAssertEqual(product.id, productId)
        XCTAssertEqual(product.title, expectedProduct.title)
        XCTAssertEqual(product, expectedProduct)
    }
    
    func testExecute_PropagatesRepositoryError() async {
        let productId = 1
        let mockRepository = ProductRepositoryMock()
        mockRepository.fetchProductDetailStub = .failure(DummyError.network)
        let useCase = FetchProductDetailsUseCase(repository: mockRepository)
        
        do {
            _ = try await useCase.execute(with: productId)
            XCTFail("Should have thrown an error")
        } catch let dummyError as DummyError  {
            XCTAssertEqual(dummyError, DummyError.network)
        } catch {
            XCTFail("Should have thrown an DummyError")
        }
        
    }
}
