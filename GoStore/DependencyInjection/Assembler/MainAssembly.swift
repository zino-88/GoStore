//
//  MainAssembly
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Defines the root assembly responsible for composing the app’s dependencies.
//  It registers shared services (e.g. persistence) and assembles feature-specific modules.
//

final class MainAssembly: DIAssembly {
    func assemble(container: DIContainer) {
        /// Persistence
        container.register(SwiftDataStack.self, scope: .singleton) {
            SwiftDataStack()
        }
        
        /// Features
        let assemblies: [DIAssembly] = [
            ProductsAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
