//
//  GoStoreTests - Clean Architecture Sample
//  Created by Zine.
//

import Foundation
import SwiftData
@testable import GoStore

enum DummyError: Error {
    case network
    case db
}

func makeInMemoryContext() -> ModelContext {
    let stack = SwiftDataStack(inMemory: true) // in-memory DB
    return stack.newContext()
}
