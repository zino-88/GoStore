//
//  SwinjectContainer
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Swinject-based implementation of the DIContainer abstraction.
//  Provides the runtime integration for dependency registration and resolution.
//

import Swinject

final class SwinjectContainer: DIContainer {
    private let container = Container()
    private lazy var safeResolver: Resolver = container.synchronize()
    
    // MARK: - Resolve
    func resolve<T>(_ type: T.Type) -> T? {
        return safeResolver.resolve(type)
    }
    
    // MARK: - Register
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        container.register(type) { _ in factory() }
    }
    
    func register<T>(_ type: T.Type, scope: DIScope, factory: @escaping () -> T) {
        let reg = container.register(type) { _ in factory() }
        if scope == .singleton {
            reg.inObjectScope(.container)
        }
    }
}
