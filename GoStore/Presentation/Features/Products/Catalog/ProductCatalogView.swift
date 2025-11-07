//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import SwiftUI

struct ProductCatalogView: View {
    @Environment(\.viewModelFactory) private var factoryOpt
    private var factory: ViewModelFactory {
        guard let vmFactory = factoryOpt else {
            fatalError("Missing ViewModelFactory")
        }
        return vmFactory
    }
    
        
    private var viewModel: ProductCatalogViewModel
    @State private var hasCalledLoad: Bool = false
    
    init(viewModel: ProductCatalogViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            GridView(items: viewModel.products) { product in
                ProductItemView(
                    viewModel: factory.makeProductItemViewModel(
                        summary: product.summary,
                        isFavorite: viewModel.isFavoriteProduct(product)
                    )
                )
            }
            .loadingOverlay(isLoading: viewModel.isLoading)
            .navigationTitle("Products")
            .task {
                if !hasCalledLoad {
                    await viewModel.loadProducts()
                    hasCalledLoad = true
                }
            }
            .refreshable {
                Task {
                    await viewModel.reloadProducts()
                }
            }
            .errorAlert(viewModel.productLoadError, onRetry: {
                Task { await viewModel.reloadProducts() }
            })
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(
                    viewModel: factory.makeProductDetailViewModel(product: product)
                )
            }
        }
    }
}

#if DEBUG

#Preview {
    ProductCatalogView(
        viewModel: PreviewViewModelFactory.shared.makeProductCatalogViewModel()
    )
}

#endif
