//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import Foundation
import Combine

@MainActor
@Observable
class FavoriteProductsViewModel {
    
    // MARK: - UI State
    private(set) var favoriteProducts: [FavoriteProduct] = []
    
    // MARK: - Dependencies
    private let observeFavoritesUseCase: ObserveFavoriteProductsUseCase
    
    // MARK: - Subscriptions
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(observeFavoritesUseCase: ObserveFavoriteProductsUseCase) {
        self.observeFavoritesUseCase = observeFavoritesUseCase
        
        setupObservers()
    }
    
    // MARK: - Public Methods

    
    // MARK: - Private Methods

    private func setupObservers() {
        observeFavoritesUseCase.execute()
            .compactMap { try? $0.get() }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                self?.favoriteProducts = favorites
            }
            .store(in: &cancellables)
    }
}


