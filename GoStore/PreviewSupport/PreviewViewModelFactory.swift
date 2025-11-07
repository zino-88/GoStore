//
//  PreviewViewModelFactory
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Debug-only implementation of the ViewModelFactory protocol.
//  It builds view models with fake repositories and mocks to simulate data
//  without requiring real API or persistence dependencies.
//
//  - Particularly useful for SwiftUI previews.
//

#if DEBUG

final class PreviewViewModelFactory: ViewModelFactory {
    static let shared: PreviewViewModelFactory = .init()
    
    func makeProductItemViewModel(summary: ProductSummary, isFavorite: Bool) -> ProductItemViewModel {
        ProductItemViewModel(
            product: summary,
            isFavorite: isFavorite
        )
    }
    
    func makeProductCatalogViewModel() -> ProductCatalogViewModel {
        let fetchUseCase = FetchProductsUseCase(
            repository: FakeProductRepository()
        )
        let observeUseCase = ObserveFavoriteProductsUseCase(
            repository: FakeFavoriteProductRepository()
        )
        
        return ProductCatalogViewModel(
            fetchUseCase: fetchUseCase,
            observeFavoritesUseCase: observeUseCase
        )
    }
    
    func makeProductDetailViewModel(product: Product) -> ProductDetailViewModel {
        let favoriteProductRepository = FakeFavoriteProductRepository()
        
        let toggleFavoriteUseCase = ToggleFavoriteProductUseCase(
            repository: favoriteProductRepository
        )

        let observeFavoritesUseCase = ObserveFavoriteProductsUseCase(
            repository: favoriteProductRepository
        )
        
        let markAsSeenUseCase = MarkProductAsSeenUseCase(
            repository: FakeSeenProductRepository()
        )
        
        return ProductDetailViewModel(
            product: product,
            observeFavoritesUseCase: observeFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            markAsSeenUseCase: markAsSeenUseCase
        )
    }
    
    func makeProductDetailViewModel(productId: Int) -> ProductDetailViewModel {
        return makeProductDetailViewModel(product: Product.mock(id: productId) ?? Product.mock)
    }
    
    func makeFavoriteProductsViewModel() -> FavoriteProductsViewModel {
        let observeUseCase = ObserveFavoriteProductsUseCase(
            repository: FakeFavoriteProductRepository()
        )
        
        return FavoriteProductsViewModel(observeFavoritesUseCase: observeUseCase)
    }
    
    func makeSeenProductsViewModel() -> SeenProductsViewModel {
        let observeSeenUseCase = ObserveSeenProductsUseCase(
            repository: FakeSeenProductRepository()
        )

        let observeFavoritesUseCase = ObserveFavoriteProductsUseCase(
            repository: FakeFavoriteProductRepository()
        )
        
        let clearHistoryUseCase = ClearSeenProductsHistoryUseCase(
            repository: FakeSeenProductRepository()
        )
        
        return SeenProductsViewModel(
            observeSeenUseCase: observeSeenUseCase,
            observeFavoritesUseCase: observeFavoritesUseCase,
            clearHistoryUseCase: clearHistoryUseCase
        )
    }
}

#endif
