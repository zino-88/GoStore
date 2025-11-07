//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import SwiftUI

@main
struct GoStoreApp: App {
    private let viewModelFactory: ViewModelFactory
    private var appUIState: AppUIState
    
    init() {
        let container = SwinjectContainer()
        let mainAssembly = MainAssembly()
        mainAssembly.assemble(container: container)
        
        self.viewModelFactory = DefaultViewModelFactory(container: container)
        
        guard let observefavoriteProductsUseCase = container.resolve(ObserveFavoriteProductsUseCase.self) else {
            fatalError("ObserveFavoriteProductsUseCase not registered")
        }
        guard let observeSeenProductsUseCase = container.resolve(ObserveSeenProductsUseCase.self) else {
            fatalError("ObserveSeenProductsUseCase not registered")
        }
        self.appUIState = AppUIState(
            observeFavoriteProductsUseCase: observefavoriteProductsUseCase,
            observeSeenProductsUseCase: observeSeenProductsUseCase
        )
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ProductCatalogTab(
                    viewModel: viewModelFactory.makeProductCatalogViewModel()
                )
                
                FavoriteProductsTab(
                    viewModel: viewModelFactory.makeFavoriteProductsViewModel()
                )
                
                SeenProductsTab(
                    viewModel: viewModelFactory.makeSeenProductsViewModel()
                )
            }
            .environment(\.viewModelFactory, viewModelFactory)
            .environment(appUIState)
        }
    }
}
