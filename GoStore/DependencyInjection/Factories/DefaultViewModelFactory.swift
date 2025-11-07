//
//  DefaultViewModelFactory
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Concrete implementation of the ViewModelFactory protocol used at runtime.
//  It builds view models by resolving their required dependencies
//  from the preconfigured dependency injection container.
//

final class DefaultViewModelFactory: ViewModelFactory {
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func makeProductItemViewModel(summary: ProductSummary, isFavorite: Bool) -> ProductItemViewModel {
        return ProductItemViewModel(product: summary, isFavorite: isFavorite)
    }
    
    func makeProductCatalogViewModel() -> ProductCatalogViewModel {
        guard let fetchUseCase = container.resolve(FetchProductsUseCase.self) else {
            fatalError("FetchProductsUseCase not found")
        }
        
        guard let observeFavoriteUseCase = container.resolve(ObserveFavoriteProductsUseCase.self) else {
            fatalError("ObserveFavoriteProductsUseCase not found")
        }
        
        return ProductCatalogViewModel(fetchUseCase: fetchUseCase, observeFavoritesUseCase: observeFavoriteUseCase)
    }
    
    func makeProductDetailViewModel(product: Product) -> ProductDetailViewModel {
        guard let markAsSeenUseCase = container.resolve(MarkProductAsSeenUseCase.self) else {
            fatalError("MarkProductAsSeenUseCase not found")
        }
        
        guard let toggleFavoriteUseCase = container.resolve(ToggleFavoriteProductUseCase.self) else {
            fatalError("ToggleFavoriteProductUseCase not found")
        }
        
        guard let observeFavoritesUseCase = container.resolve(ObserveFavoriteProductsUseCase.self) else {
            fatalError("ObserveFavoriteProductsUseCase not found")
        }
        
        return ProductDetailViewModel(product: product,
                                      observeFavoritesUseCase: observeFavoritesUseCase,
                                      toggleFavoriteUseCase: toggleFavoriteUseCase,
                                      markAsSeenUseCase: markAsSeenUseCase
        )
    }
    
    func makeProductDetailViewModel(productId: Int) -> ProductDetailViewModel {
        guard let fetchUseCase = container.resolve(FetchProductDetailsUseCase.self) else {
            fatalError("FetchProductDetailsUseCase not found")
        }
        
        guard let toggleFavoriteUseCase = container.resolve(ToggleFavoriteProductUseCase.self) else {
            fatalError("ToggleFavoriteProductUseCase not found")
        }
        
        guard let markAsSeenUseCase = container.resolve(MarkProductAsSeenUseCase.self) else {
            fatalError("MarkProductAsSeenUseCase not found")
        }
        
        guard let observeFavoritesUseCase = container.resolve(ObserveFavoriteProductsUseCase.self) else {
            fatalError("ObserveFavoriteProductsUseCase not found")
        }
        
        return ProductDetailViewModel(productId: productId,
                                      fetchProductDetailsUseCase: fetchUseCase,
                                      observeFavoritesUseCase: observeFavoritesUseCase,
                                      toggleFavoriteUseCase: toggleFavoriteUseCase,
                                      markAsSeenUseCase: markAsSeenUseCase
        )
    }
    
    func makeFavoriteProductsViewModel() -> FavoriteProductsViewModel {
        guard let observeFavoritesUseCase = container.resolve(ObserveFavoriteProductsUseCase.self) else {
            fatalError("ObserveFavoriteProductsUseCase not found")
        }
        
        return FavoriteProductsViewModel(observeFavoritesUseCase: observeFavoritesUseCase)
    }
    
    func makeSeenProductsViewModel() -> SeenProductsViewModel {
        guard let observeSeenUseCase = container.resolve(ObserveSeenProductsUseCase.self) else {
            fatalError("ObserveSeenProductsUseCase not found")
        }
        
        guard let observeFavoritesUseCase = container.resolve(ObserveFavoriteProductsUseCase.self) else {
            fatalError("ObserveFavoriteProductsUseCase not found")
        }
        
        guard let clearHistoryUseCase = container.resolve(ClearSeenProductsHistoryUseCase.self) else {
            fatalError("ClearSeenProductsHistoryUseCase not found")
        }
        
        return SeenProductsViewModel(
            observeSeenUseCase: observeSeenUseCase,
            observeFavoritesUseCase: observeFavoritesUseCase,
            clearHistoryUseCase: clearHistoryUseCase
        )
    }
}

