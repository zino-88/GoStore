//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import Foundation
import Combine

@MainActor
@Observable
class SeenProductsViewModel {
    
    // MARK: - UI State
    private(set) var seenProducts: [SeenProduct] = []
    private(set) var actionError: Error?
    
    // MARK: - Derived State
    private var favoriteIds : Set<Int> = []
    
    func isFavoriteProduct(_ product: SeenProduct) -> Bool {
        favoriteIds.contains(product.id)
    }
       
    // MARK: - Dependencies
    private let observeSeenUseCase: ObserveSeenProductsUseCase
    private let observeFavoritesUseCase: ObserveFavoriteProductsUseCase
    private let clearHistoryUseCase: ClearSeenProductsHistoryUseCase
    
    // MARK: - Subscriptions
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        observeSeenUseCase: ObserveSeenProductsUseCase,
        observeFavoritesUseCase: ObserveFavoriteProductsUseCase,
        clearHistoryUseCase: ClearSeenProductsHistoryUseCase
    ) {
        self.observeSeenUseCase = observeSeenUseCase
        self.observeFavoritesUseCase = observeFavoritesUseCase
        self.clearHistoryUseCase = clearHistoryUseCase
        
        setupObservers()
    }
    
    // MARK: - Public Methods
    
    func clearHistory() {
        do {
            try clearHistoryUseCase.execute()
        } catch {
            actionError = error
        }
    }
    
    func clearActionError() {
        actionError = nil
    }
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        observeSeenUseCase.execute()
            .compactMap { try? $0.get() }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.seenProducts = products
            }
            .store(in: &cancellables)
        
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
