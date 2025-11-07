//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    private var viewModel: ProductDetailViewModel
    
    @State private var hasCalledMarkAsSeen = false

    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if let product = viewModel.product {
                productContent(product)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .loadingOverlay(isLoading: viewModel.isLoading)
        .toolbar {
            if let _ = viewModel.product {
                ToolbarItem(placement: .navigationBarTrailing) {
                    favoriteButton
                }
            }
        }
        .task {
            await viewModel.loadIfNeeded()
            if let _ = viewModel.product, !hasCalledMarkAsSeen {
                viewModel.markProductAsSeen()
                hasCalledMarkAsSeen = true
            }
        }
        .errorAlert(viewModel.productLoadError, onRetry: {
            Task { await viewModel.reload() }
        })
        .errorAlert(viewModel.actionError, onDismiss:  {
            viewModel.clearActionError()
        })
    }
    
    // MARK: - View Components
    
    private func productContent(_ product: Product) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                productImageSection(product)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    productTitleSection(product)
                    ratingSection(product)
                    priceSection(product)
                    descriptionSection(product)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func productImageSection(_ product: Product) -> some View {
        KFImage(product.imageURL)
            .placeholder {
                ProgressView()
            }
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    struct ImagePlaceholder: View {
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                ProgressView()
            }
        }
    }
    
    private func productTitleSection(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.category.uppercased())
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.1))
                .clipShape(Capsule())
            
            Text(product.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(nil)
        }
    }
    
    private func ratingSection(_ product: Product) -> some View {
        HStack(spacing: 8) {
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= Int(product.rating.rate.rounded()) ? "star.fill" : "star")
                        .foregroundColor(index <= Int(product.rating.rate.rounded()) ? .yellow : .gray.opacity(0.3))
                        .font(.caption)
                }
            }
            
            Text(String(format: "%.1f", product.rating.rate))
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text("(\(product.rating.count) reviews)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
    
    private func priceSection(_ product: Product) -> some View {
        HStack(alignment: .bottom) {
            Text(product.price, format: .currency(code: "EUR"))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
    
    private func descriptionSection(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(product.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var favoriteButton: some View {
        Button {
            viewModel.toggleFavorite()
        } label: {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(.blue)
                .font(.title2)
        }
    }
}

#if DEBUG

#Preview {
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
    
    ProductDetailView(
        viewModel: PreviewViewModelFactory.shared.makeProductDetailViewModel(
            product: Product.mock
        )
    )
}

#endif
