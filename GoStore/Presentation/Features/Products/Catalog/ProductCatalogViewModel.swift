//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import Foundation
import Combine

@MainActor
@Observable
class ProductCatalogViewModel {
    
    // MARK: - UI State
    private(set) var products: [Product] = []
    private(set) var isLoading: Bool = false
    private(set) var productLoadError: Error?
    
    // MARK: - Derived State
    private var favoriteIds : Set<Int> = []
    
    func isFavoriteProduct(_ product: Product) -> Bool {
        return favoriteIds.contains(product.id)
    }
    
    // MARK: - Dependencies
    private let fetchUseCase: FetchProductsUseCase
    private let observeFavoritesUseCase: ObserveFavoriteProductsUseCase
    
    // MARK: - Subscriptions
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(fetchUseCase: FetchProductsUseCase,
         observeFavoritesUseCase: ObserveFavoriteProductsUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.observeFavoritesUseCase = observeFavoritesUseCase
            
        setupObservers()
    }
    
    deinit {
        print("deinit ProductCatalogViewModel")
    }
    
    // MARK: - Public Methods
    
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
                    
        do {
            products = try await fetchUseCase.execute()
        } catch {
            productLoadError = error
        }
    }
    
    func reloadProducts() async {
        productLoadError = nil

        await loadProducts()
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
