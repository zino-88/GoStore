//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

class ClearSeenProductsHistoryUseCase {
    private let repository: SeenProductRepository
    
    init(repository: SeenProductRepository) {
        self.repository = repository
    }
    
    func execute() throws {
        try repository.clearHistory()
    }
}
