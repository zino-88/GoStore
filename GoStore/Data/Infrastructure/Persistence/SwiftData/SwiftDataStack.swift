//
//  SwiftDataStack
//  Created by Zine.
//
//  A lightweight wrapper around SwiftData for model container and context management.
//

import SwiftData
import Foundation

final class SwiftDataStack {
    let container: ModelContainer
        
    init(inMemory: Bool = false) {
        do {
            let schema = Schema([
                SDProduct.self,
                SDFavoriteProduct.self,
                SDSeenProduct.self
            ])
            
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: inMemory
            )
            
            self.container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    @MainActor
    var mainContext: ModelContext {
        container.mainContext
    }
    
    func newContext() -> ModelContext {
        ModelContext(container)
    }
}
