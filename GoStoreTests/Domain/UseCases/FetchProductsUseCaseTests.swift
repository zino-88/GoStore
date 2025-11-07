//
//  FetchProductsUseCaseTests.swift
//  GoStore
//
//  Created by zine on 03/10/2025.
//

import XCTest
@testable import GoStore

final class FetchProductsUseCaseTests: XCTestCase {
    
    func testExecute_ReturnsProductsFromRepository() async throws {
        let expectedProducts = Product.mocks
        let mockRepository = ProductRepositoryMock()
        mockRepository.fetchProductsStub = .success(expectedProducts)
        let useCase = FetchProductsUseCase(repository: mockRepository)
        
        let products = try await useCase.execute()
        
        XCTAssertEqual(products.count, expectedProducts.count)
        XCTAssertEqual(products.map(\.id), expectedProducts.map(\.id))
    }
    
    func testExecute_PropagatesRepositoryError() async {
        let mockRepository = ProductRepositoryMock()
        mockRepository.fetchProductsStub = .failure(DummyError.network)
        let useCase = FetchProductsUseCase(repository: mockRepository)

        do {
            _ = try await useCase.execute()
            XCTFail("Should have thrown an error")
        } catch let dummyError as DummyError {
            XCTAssertEqual(dummyError, DummyError.network)
        } catch {
            XCTFail("Should have thrown an DummyError")
        }
    }
}
