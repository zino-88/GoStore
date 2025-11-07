//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

#if DEBUG

import Foundation

extension Product {
    static var mock: Product {
        mock1
    }
    
    static var mocks: [Product] {
        [mock1, mock2]
    }
    
    static func mock(id: Int) -> Product? {
        mocks.first { $0.id == id }
    }
    
    static let mock1 = Product(
        id: 1,
        title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        price: 109.95,
        description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        category: "men's clothing",
        imageURL: URL(string: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png")!,
        rating: Rating(
            rate: 3.9,
            count: 120
        )
    )
    
    static let mock2 = Product(
        id: 2,
        title: "Mens Casual Premium Slim Fit T-Shirts",
        price: 22.3,
        description: "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
        category: "men's clothing",
        imageURL: URL(string: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_t.png")!,
        rating: Rating(
            rate: 4.1,
            count: 259
        )
    )
}

#endif

