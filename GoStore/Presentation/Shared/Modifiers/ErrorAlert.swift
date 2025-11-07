//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  A reusable SwiftUI ViewModifier for presenting error alerts with optional retry and dismiss actions.
//

import SwiftUI

@MainActor
struct ErrorAlert: ViewModifier {
    let error: Error?
    let onRetry: (() -> Void)?
    let onDismiss: (() -> Void)?
    
    @State private var showingAlert = false
    @State private var currentError: Error?
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $showingAlert, presenting: currentError) { _ in
                if let onRetry {
                    Button("Retry") {
                        onDismiss?()
                        onRetry()
                    }
                    Button("Cancel", role: .cancel) {
                        onDismiss?()
                    }
                } else {
                    Button("OK", role: .cancel) {
                        onDismiss?()
                    }
                }
            } message: { error in
                Text(error?.localizedDescription ?? "An unexpected error occurred.")
            }
            .onChange(of: error != nil) {
                if let error = error {
                    currentError = error
                    showingAlert = true
                }
            }
    }
}

extension View {
    public func errorAlert(
        _ error: Error?,
        onRetry: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        modifier(ErrorAlert(error: error, onRetry: onRetry, onDismiss: onDismiss))
    }
}
