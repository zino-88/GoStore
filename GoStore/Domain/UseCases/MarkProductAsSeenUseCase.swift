//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

class MarkProductAsSeenUseCase {
    private let repository: SeenProductRepository
    
    init(repository: SeenProductRepository) {
        self.repository = repository
    }
    
    func execute(with product: Product) throws {
        try repository.markSeen(product)
    }
}
