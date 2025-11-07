//
//  AppUIState
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  An observable "Global UI State" reacting to domain-driven events.
//  It monitors domain use cases (e.g. favorite and seen products)
//  and exposes simplified UI state indicators (e.g. error flags)
//  shared across multiple views.
//

import Foundation
import Combine

@MainActor
@Observable
class AppUIState {
    
    // MARK: - UI State
    private(set) var hasFavoriteError = false
    private(set) var hasSeenError = false
    
    // MARK: - Dependencies
    private let observeFavoriteProductsUseCase: ObserveFavoriteProductsUseCase
    private let observeSeenProductsUseCase: ObserveSeenProductsUseCase
    
    // MARK: - Subscriptions
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        observeFavoriteProductsUseCase: ObserveFavoriteProductsUseCase,
        observeSeenProductsUseCase: ObserveSeenProductsUseCase
    ) {
        self.observeFavoriteProductsUseCase = observeFavoriteProductsUseCase
        self.observeSeenProductsUseCase = observeSeenProductsUseCase
        
        setupObservers()
    }
    
    // MARK: - Setup
    
    private func setupObservers() {
        observeFavoriteProductsUseCase.execute()
            .map { result in
                switch result {
                case .success: return false
                case .failure: return true
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasError in
                self?.hasFavoriteError = hasError
            }
            .store(in: &cancellables)
        
        observeSeenProductsUseCase.execute()
            .map { result in
                switch result {
                case .success: return false
                case .failure: return true
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasError in
                self?.hasSeenError = hasError
            }
            .store(in: &cancellables)
    }
}
