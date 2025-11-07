//
//  DIContainer
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Dependency Injection abstraction, defining registration and resolution contracts.
//  Provides a lightweight interface to decouple app components from any external DI libraries.
//

enum DIScope {
    case transient
    case singleton
}

protocol DIContainer {
    func resolve<T>(_ type: T.Type) -> T?
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    func register<T>(_ type: T.Type, scope: DIScope, factory: @escaping () -> T)
}
