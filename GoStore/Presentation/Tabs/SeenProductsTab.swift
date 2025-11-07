//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import SwiftUI

struct SeenProductsTab: View {
    @Environment(AppUIState.self) private var appUIState
    
    private let viewModel: SeenProductsViewModel
    
    init(viewModel: SeenProductsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        SeenProductsView(viewModel: viewModel)
            .tabItem {
                Label("Recents", systemImage: "clock.fill")
            }
            .badge(appUIState.hasSeenError ? "!" : nil)
    }
}
