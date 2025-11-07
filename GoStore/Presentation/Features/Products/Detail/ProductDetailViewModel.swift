//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import Foundation
import Combine

@MainActor
@Observable
class ProductDetailViewModel {
    
    // MARK: - UI State
    private(set) var product: Product?
    private(set) var isLoading: Bool = false
    private(set) var productLoadError: Error?
    private(set) var actionError: Error?
    
    // MARK: - Derived State
    private var favoriteIds : Set<Int> = []
    
    var isFavorite: Bool {
        guard let product else { return false }
        return favoriteIds.contains(product.id)
    }

    // MARK: Dependencies
    private let productId: Int?
    private let fetchProductDetailsUseCase: FetchProductDetailsUseCase?
    private let observeFavoritesUseCase: ObserveFavoriteProductsUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteProductUseCase
    private let markAsSeenUseCase: MarkProductAsSeenUseCase
    
    
    // MARK: - Subscriptions
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    convenience init(
        product: Product,
        observeFavoritesUseCase: ObserveFavoriteProductsUseCase,
        toggleFavoriteUseCase: ToggleFavoriteProductUseCase,
        markAsSeenUseCase: MarkProductAsSeenUseCase
    ) {
        self.init(
            product: product,
            productId: nil,
            fetchProductDetailsUseCase: nil,
            observeFavoritesUseCase: observeFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            markAsSeenUseCase: markAsSeenUseCase
        )
    }
    
    convenience init(
        productId: Int,
        fetchProductDetailsUseCase: FetchProductDetailsUseCase,
        observeFavoritesUseCase: ObserveFavoriteProductsUseCase,
        toggleFavoriteUseCase: ToggleFavoriteProductUseCase,
        markAsSeenUseCase: MarkProductAsSeenUseCase
    ) {
        self.init(
            product: nil,
            productId: productId,
            fetchProductDetailsUseCase: fetchProductDetailsUseCase,
            observeFavoritesUseCase: observeFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            markAsSeenUseCase: markAsSeenUseCase
        )
    }
    
    private init(
        product: Product?,
        productId: Int?,
        fetchProductDetailsUseCase: FetchProductDetailsUseCase?,
        observeFavoritesUseCase: ObserveFavoriteProductsUseCase,
        toggleFavoriteUseCase: ToggleFavoriteProductUseCase,
        markAsSeenUseCase: MarkProductAsSeenUseCase
    ) {
        self.product = product
        self.productId = productId
        self.fetchProductDetailsUseCase = fetchProductDetailsUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.markAsSeenUseCase = markAsSeenUseCase
        self.observeFavoritesUseCase = observeFavoritesUseCase
        
        
        setupObservers()
    }
    
    // MARK: - Public Methods
    
    func loadIfNeeded() async {
        guard product == nil, let productId, let fetchProductDetailsUseCase else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            product = try await fetchProductDetailsUseCase.execute(with: productId)
        } catch {
            productLoadError = error
        }
    }
    
    func reload() async {
        product = nil
        productLoadError = nil
        
        await loadIfNeeded()
    }
    
    func toggleFavorite() {
        guard let product else { return }
        
        do {
            try toggleFavoriteUseCase.execute(with: product)
        } catch {
            actionError = error
        }
    }
    
    func markProductAsSeen() {
        guard let product else { return }
        
        do {
            try markAsSeenUseCase.execute(with: product)
        } catch {
            print("⚠️ Failed to mark product as seen: \(error)")
        }
    }
    
    func clearActionError() {
        actionError = nil
    }
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        observeFavoritesUseCase.execute()
            .compactMap { try? $0.get() }
            .map { Set($0.map { $0.id }) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] productIds in
                self?.favoriteIds = productIds
            }
            .store(in: &cancellables)
    }
    
}


