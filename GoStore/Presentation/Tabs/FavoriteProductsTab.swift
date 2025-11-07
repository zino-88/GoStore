//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import SwiftUI

struct FavoriteProductsTab: View {
    @Environment(AppUIState.self) private var appUIState
    
    private let viewModel: FavoriteProductsViewModel
    
    init(viewModel: FavoriteProductsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        FavoriteProductsView(viewModel: viewModel)
            .tabItem {
                Label("My List", systemImage: "heart.fill")
            }
            .badge(appUIState.hasFavoriteError ? "!" : nil)
    }
}
