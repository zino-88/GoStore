//
//  ModelContext+Convenience
//  Created by Zine.
//
//  Convenience extensions for common SwiftData ModelContext operations.
//

import Foundation
import SwiftData

extension ModelContext {
    
    // MARK: - Fetch Convenience
    
    func fetch<T>(
        model: T.Type,
        where predicate: Predicate<T>? = nil,
        sortBy sortDescriptors: [SortDescriptor<T>] = [],
        limit: Int? = nil
    ) throws -> [T] where T: PersistentModel {
        var descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortDescriptors)
        descriptor.fetchLimit = limit
        
        return try fetch(descriptor)
    }
    
    func fetchOne<T>(model: T.Type, where predicate: Predicate<T>? = nil) throws -> T? where T: PersistentModel {
        try fetch(model: model, where: predicate, limit: 1).first
    }
    
    func fetchCount<T>(model: T.Type, where predicate: Predicate<T>? = nil) throws -> Int where T: PersistentModel {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        return try fetchCount(descriptor)
    }
    
    func exists<T>(model: T.Type, where predicate: Predicate<T>? = nil) throws -> Bool where T: PersistentModel {
        try fetchCount(model: model, where: predicate) > 0
    }
}
