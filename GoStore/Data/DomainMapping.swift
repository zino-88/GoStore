//
//  DomainMapping
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Defines mapping protocols for converting models to and from the Domain layer.
//

import Foundation

protocol DomainConvertible {
    associatedtype DomainEntity
    func toDomain() -> DomainEntity
}

protocol DomainConstructable {
    associatedtype DomainEntity
    static func fromDomain(_ domain: DomainEntity) -> Self
    mutating func update(from domain: DomainEntity)
}

extension DomainConstructable {
    func update(from domain: DomainEntity) {}
}


typealias DomainMappable = DomainConvertible & DomainConstructable






