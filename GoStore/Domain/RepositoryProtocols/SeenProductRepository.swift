//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import Combine

typealias SeenProductsResult = Result<[SeenProduct], Error>

protocol SeenProductRepository {
    func getSeenProducts() throws -> [SeenProduct]
    func markSeen(_ product: Product) throws
    func isSeen(_ product: Product) throws -> Bool
    func clearHistory() throws
    
    func observeSeenProducts() -> AnyPublisher<SeenProductsResult, Never>
}
