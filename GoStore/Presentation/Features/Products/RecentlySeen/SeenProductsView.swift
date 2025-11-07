//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import SwiftUI

struct SeenProductsView: View {
    @Environment(\.viewModelFactory) private var factoryOpt
    private var factory: ViewModelFactory {
        guard let vmFactory = factoryOpt else {
            fatalError("Missing ViewModelFactory")
        }
        return vmFactory
    }
    
    private var viewModel: SeenProductsViewModel
    @State private var showClearConfirmation = false
    
    init(viewModel: SeenProductsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            GridView(items: viewModel.seenProducts) { seenProduct in
                ProductItemView(
                    viewModel: factory.makeProductItemViewModel(
                        summary: seenProduct.summary,
                        isFavorite: viewModel.isFavoriteProduct(seenProduct)
                    )
                )
            }
            .navigationTitle("Recently Viewed")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    clarButton
                }
            }
            .confirmationDialog(
                "Clear History",
                isPresented: $showClearConfirmation,
                titleVisibility: .visible,
                actions: { clearConfirmationActions },
                message: { Text("This will remove all recently viewed products.") }
            )
            .errorAlert(viewModel.actionError, onDismiss: {
                viewModel.clearActionError()
            })
            .navigationDestination(for: SeenProduct.self) { seenProduct in
                ProductDetailView(
                    viewModel: factory.makeProductDetailViewModel(productId: seenProduct.id)
                )
            }
        }
    }
    
    private var clarButton: some View {
        Button(role: .destructive) {
            showClearConfirmation = true
        } label: {
            Image(systemName: "trash")
        }
        .disabled(viewModel.seenProducts.isEmpty)
    }
    
    @ViewBuilder
    private var clearConfirmationActions: some View {
        Button("Clear All History", role: .destructive) {
            viewModel.clearHistory()
        }
        Button("Cancel", role: .cancel) { }
    }
}

#if DEBUG

#Preview {
    SeenProductsView(
        viewModel: PreviewViewModelFactory.shared.makeSeenProductsViewModel()
    )
}

#endif

