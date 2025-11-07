//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  A generic two-column SwiftUI grid layout for displaying any identifiable and hashable items.
//

import SwiftUI

struct GridView<Item: Identifiable & Hashable, Content: View>: View {
    let items: [Item]
    @ViewBuilder let content: (Item) -> Content
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        content(item)
                    }
                }
            }
            .padding()
        }
    }
}
