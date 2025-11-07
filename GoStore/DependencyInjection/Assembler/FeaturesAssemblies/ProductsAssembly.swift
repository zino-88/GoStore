//
//  ProductsAssembly
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Defines the dependency assembly for the Products feature.
//  It registers repositories and use cases related to products, favorites, and recently seen items.
//

final class ProductsAssembly: DIAssembly {
    func assemble(container: DIContainer) {
        
        // Repositories
        container.register(ProductRepository.self, scope: .singleton) {
            FSProductRepository()
        }
        
        container.register(FavoriteProductRepository.self, scope: .singleton) {
            guard let stack = container.resolve(SwiftDataStack.self) else {
                fatalError("SwiftDataStack not found")
            }
            return SDFavoriteProductRepository(context: stack.mainContext, observationEnabled: true)
        }
        
        container.register(SeenProductRepository.self, scope: .singleton) {
            guard let stack = container.resolve(SwiftDataStack.self) else {
                fatalError("SwiftDataStack not found")
            }
            return SDSeenProductRepository(context: stack.mainContext, observationEnabled: true)
        }
        
        // UseCases
        container.register(FetchProductsUseCase.self) {
            guard let repository = container.resolve(ProductRepository.self) else {
                fatalError("ProductRepository not found")
            }
            return FetchProductsUseCase(repository: repository)
        }
        
        container.register(FetchProductDetailsUseCase.self) {
            guard let repository = container.resolve(ProductRepository.self) else {
                fatalError("ProductRepository not found")
            }
            return FetchProductDetailsUseCase(repository: repository)
        }
        
        container.register(ObserveFavoriteProductsUseCase.self) {
            guard let repository = container.resolve(FavoriteProductRepository.self) else {
                fatalError("FavoriteProductRepository not found")
            }
            return ObserveFavoriteProductsUseCase(repository: repository)
        }
        
        container.register(ObserveSeenProductsUseCase.self) {
            guard let repository = container.resolve(SeenProductRepository.self) else {
                fatalError("SeenProductRepository not found")
            }
            return ObserveSeenProductsUseCase(repository: repository)
        }
        
        container.register(ToggleFavoriteProductUseCase.self) {
            guard let repository = container.resolve(FavoriteProductRepository.self) else {
                fatalError("FavoriteProductRepository not found")
            }
            return ToggleFavoriteProductUseCase(repository: repository)
        }
        
        container.register(MarkProductAsSeenUseCase.self) {
            guard let repository = container.resolve(SeenProductRepository.self) else {
                fatalError("SeenProductRepository not found")
            }
            return MarkProductAsSeenUseCase(repository: repository)
        }
        
        container.register(ClearSeenProductsHistoryUseCase.self) {
            guard let repository = container.resolve(SeenProductRepository.self) else {
                fatalError("SeenProductRepository not found")
            }
            return ClearSeenProductsHistoryUseCase(repository: repository)
        }
    }
}
