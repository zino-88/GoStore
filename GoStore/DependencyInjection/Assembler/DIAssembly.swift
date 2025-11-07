//
//  DIAssembly
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Defines a component responsible for registering dependencies
//  of a specific feature or module into the DI container.
//

@MainActor
protocol DIAssembly {
    func assemble(container: DIContainer)
}
