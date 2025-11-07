//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import SwiftUI

struct FavoriteProductsView: View {
    @Environment(\.viewModelFactory) private var factoryOpt
    private var factory: ViewModelFactory {
        guard let vmFactory = factoryOpt else {
            fatalError("Missing ViewModelFactory")
        }
        return vmFactory
    }
    
    private var viewModel: FavoriteProductsViewModel
    
    init(viewModel: FavoriteProductsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            GridView(items: viewModel.favoriteProducts) { favoriteProduct in
                ProductItemView(
                    viewModel: factory.makeProductItemViewModel(
                        summary: favoriteProduct.summary,
                        isFavorite: true)
                )
            }
            .navigationTitle("Favorites Products")
            .navigationDestination(for: FavoriteProduct.self) { favoriteProduct in
                ProductDetailView(
                    viewModel: factory.makeProductDetailViewModel(productId: favoriteProduct.id)
                )
            }
            
        }
    }
}

#if DEBUG

#Preview {
    FavoriteProductsView(
        viewModel: PreviewViewModelFactory.shared.makeFavoriteProductsViewModel()
    )
}

#endif

