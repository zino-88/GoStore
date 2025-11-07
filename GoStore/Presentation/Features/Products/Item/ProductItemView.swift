//
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//

import SwiftUI
import Kingfisher

struct ProductItemView: View {
    private let viewModel: ProductItemViewModel
    
    init(viewModel: ProductItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                KFImage(viewModel.product.imageURL)
                    .placeholder {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                Text(viewModel.product.title)
                    .font(.footnote)
                    .bold()
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text(viewModel.product.price, format: .currency(code: "EUR"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(height: 250)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            if viewModel.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
                    .padding(5)
            }
        }
    }
}

#if DEBUG

#Preview {
    ProductItemView(
        viewModel: PreviewViewModelFactory.shared.makeProductItemViewModel(
            summary: Product.mock.summary,
            isFavorite: true
        )
    )
}

#endif
