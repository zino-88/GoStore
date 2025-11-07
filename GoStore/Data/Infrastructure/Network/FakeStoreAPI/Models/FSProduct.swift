//
//  FSProduct
//  Created by Zine.
//
//  Data model representing a product from the FakeStore API.
//

import Foundation

public struct FSProduct: Codable, Sendable {
    public let id: Int
    public let title: String
    public let price: Double
    public let description: String
    public let category: String
    public let image: URL
    public let rating: FSRating
    
    public struct FSRating: Codable, Sendable {
        public let rate: Double
        public let count: Int
    }
}
