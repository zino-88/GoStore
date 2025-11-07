//
//  FakeStoreProductsEndpoint
//  Created by Zine.
//
//  Defines endpoints for the FakeStore API /products resource.
//

import APIClientCore

enum FakeStoreProductsEndpoint: APIEndpoint {
    case list                               // GET /products
    case create(_ product: FSProduct)       // POST /products
    case item(_ productId: Int)             // GET /products/{id}
    case update(_ product: FSProduct)       // PUT /products/{id}
    case delete(_ productId: Int)           // DELETE /products/{id}
    
    var path: String {
        switch self {
        case .list, .create:
            return "products"
        case .item(let productId), .delete(let productId):
            return "products/\(productId)"
        case .update(let product):
            return "products/\(product.id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .item: return .get
        case .create:      return .post
        case .update:      return .put
        case .delete:      return .delete
        }
    }
    
    var headers: [String : String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var body: (any Encodable)? {
        switch self {
        case .create(let product):
            return product
        case .update(let product):
            return product
        default:
            return nil
        }
    }
}
