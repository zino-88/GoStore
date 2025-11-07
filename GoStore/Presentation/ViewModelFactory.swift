//
//  ViewModelFactory
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Abstraction defining factory methods for creating SwiftUI view models.
//  It standardizes view model creation across the app to keep it consistent.
//

@MainActor
protocol ViewModelFactory {
    func makeProductItemViewModel(summary: ProductSummary, isFavorite: Bool) -> ProductItemViewModel
    
    func makeProductCatalogViewModel() -> ProductCatalogViewModel
    
    func makeProductDetailViewModel(product: Product) -> ProductDetailViewModel
    
    func makeProductDetailViewModel(productId: Int) -> ProductDetailViewModel
    
    func makeFavoriteProductsViewModel() -> FavoriteProductsViewModel
    
    func makeSeenProductsViewModel() -> SeenProductsViewModel 
}

