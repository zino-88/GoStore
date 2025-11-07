//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import SwiftUI

struct ProductCatalogTab: View {
    private let viewModel: ProductCatalogViewModel
    
    init(viewModel: ProductCatalogViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ProductCatalogView(viewModel: viewModel)
            .tabItem {
                Label("Catalog", systemImage: "cart")
            }
    }
}
