//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  A SwiftUI ViewModifier displaying a loading indicator overlay.
//

import SwiftUI

struct LoadingOverlay: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        content.overlay {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground).opacity(0.8))
            }
        }
    }
}

extension View {
    func loadingOverlay(isLoading: Bool) -> some View {
        modifier(LoadingOverlay(isLoading: isLoading))
    }
}
