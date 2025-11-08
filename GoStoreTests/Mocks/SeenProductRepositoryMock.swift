//
//  GoStoreTests - Clean Architecture Sample
//  Created by Zine.
//

import Foundation
import Combine
@testable import GoStore

final class SeenProductRepositoryMock: SeenProductRepository {
    
    // MARK: - Stubs
    var getSeenProductsStub: SeenProductsResult = .success([])
    var markSeenProductStub: Result<Void, Error> = .success(())
    var isSeenProductStub: Result<Bool, Error> = .success(false)
    var clearHistoryStub: Result<Void, Error> = .success(())
    private let observeSubject = PassthroughSubject<SeenProductsResult, Never>()
    
    
    // MARK: - Spy
    private(set) var getSeenProductsCalled = false
    private(set) var markSeenProductCalled = false
    private(set) var isSeenProductCalled = false
    private(set) var clearHistoryCalled = false
    private(set) var observeSeenProductsCalled = false
    
    private(set) var markedSeenProducts: [Product] = []
    private(set) var checkedProducts: [Product] = []
    
    
    // MARK: - Conformance
    func getSeenProducts() throws -> [SeenProduct] {
        getSeenProductsCalled = true
        return try getSeenProductsStub.get()
    }
    
    func markSeen(_ product: Product) throws {
        markSeenProductCalled = true
        markedSeenProducts.append(product)
        try markSeenProductStub.get()
    }
    
    func isSeen(_ product: Product) throws -> Bool {
        isSeenProductCalled = true
        checkedProducts.append(product)
        return try isSeenProductStub.get()
    }
    
    func observeSeenProducts() -> AnyPublisher<SeenProductsResult, Never> {
        observeSeenProductsCalled = true
        return observeSubject.eraseToAnyPublisher()
    }
    
    func clearHistory() throws {
        clearHistoryCalled = true
        markedSeenProducts.removeAll()
        try clearHistoryStub.get()
    }
    
    // MARK: - Test helpers
    func sendObserve(_ value: SeenProductsResult) {
        observeSubject.send(value)
    }
}
