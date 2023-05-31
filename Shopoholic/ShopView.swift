//
//  ShopView.swift
//  Shopoholic
//
//  Created by Соболев Пересвет on 5/27/23.
//

import SwiftUI

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let discount: Double? // Discount percentage (e.g., 0.2 for 20% discount)
    let description: String?
}

struct ShopView: View {
    let mockProducts: [Product] = [
        Product(name: "iPhone 13 Pro", price: 999.99, discount: nil, description: "The most advanced iPhone yet."),
        Product(name: "MacBook Pro 16-inch", price: 2399.99, discount: 0.15, description: "Unleash your creativity."),
        Product(name: "Apple Watch Series 7", price: 399.99, discount: nil, description: "Your health on your wrist."),
        Product(name: "AirPods Pro", price: 249.99, discount: 0.1, description: "Immerse yourself in high-quality sound."),
        Product(name: "iPad Air", price: 599.99, discount: 0.2, description: "Powerful. Colorful. Wonderful."),
        Product(name: "iMac 27-inch", price: 1799.99, discount: nil, description: "All-in-one, all in color."),
        Product(name: "Apple TV 4K", price: 179.99, discount: 0.05, description: "Enjoy your favorite shows and movies."),
        Product(name: "HomePod mini", price: 99.99, discount: nil, description: "Big sound. Smaller size."),
        Product(name: "Beats Solo3 Wireless Headphones", price: 199.99, discount: nil, description: "Designed for sound. Tuned for emotion."),
        Product(name: "Magic Keyboard for iPad Pro", price: 349.99, discount: 0.25, description: "Type like a pro."),
        // Add more products as needed
    ]
    
    let trendingProducts: [Product] = [
        Product(name: "iPhone 14 Pro", price: 1199.99, discount: nil, description: nil),
        Product(name: "Apple Watch Series 8", price: 599.99, discount: nil, description: nil),
        Product(name: "iPad Pro", price: 1399.99, discount: 0.2, description: nil)]
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TrendingItemsView(trendingItems: trendingProducts)
                        .frame(height: 200) // Adjust the height as needed
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(mockProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCardView(product: product)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct TrendingItemsView: View {
    let trendingItems: [Product]
    @State private var selectedTabIndex = 0
    @State private var isAutomaticScrolling = true
    private var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    init(trendingItems: [Product]) {
        self.trendingItems = trendingItems
        UIPageControl.appearance().currentPageIndicatorTintColor = .gray
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            ForEach(trendingItems.indices, id: \.self) { index in
                NavigationLink(destination: ProductDetailView(product: trendingItems[index])) {
                    ProductCardView(product: trendingItems[index])
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .onReceive(timer) { _ in
            withAnimation {
                let newIndex = (selectedTabIndex + 1) % trendingItems.count
                selectedTabIndex = newIndex
            }
        }
    }
    
}

struct ProductCardView: View {
    let product: Product
    @State private var isFavorite = false
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "photo") // Replace with your product image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
            
            Text(product.name)
                .font(.headline)
                .foregroundColor(Color.black)
            
            Text(product.description ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                if let discountPrice = calculateDiscountedPrice() {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(discountPrice)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text(formatPrice(product.price))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .strikethrough()
                    }
                } else {
                    Text(formatPrice(product.price))
                        .font(.headline)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button(action: {
                    isFavorite.toggle()
                    // Handle favorite list logic here
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.pink)
                        .font(.system(size: 25))
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
    }
    
    
    private func calculateDiscountedPrice() -> String? {
        guard let discount = product.discount else {
            return nil
        }
        
        let discountedPrice = product.price * (1 - discount)
        return formatPrice(discountedPrice)
    }
    
    private func formatPrice(_ price: Double) -> String {
        let number = NSNumber(value: price)
        return numberFormatter.string(from: number) ?? ""
    }
}

struct ProductDetailView: View {
    let product: Product
    @State private var isExpanded = false
    @State private var quantity = 1
    let rating: Double = 1.5
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Product Image in transparent tab view
                ZStack {
                    Image(systemName: "photo") // Replace with your product image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.main.bounds.height * 0.65)
                        .clipped()
                        .opacity(isExpanded ? 0.5 : 1.0)
                        .onTapGesture {
                            isExpanded.toggle()
                        }
                    
                    if isExpanded {
                        VStack {
                            Text("More Detailed Information")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                            // Additional detailed product information
                            // ...
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.7))
                    }
                }
                
                // Key Points
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    KeyPointView(imageName: "performance", description: "Best Performance")
                    KeyPointView(imageName: "megapixels", description: "18 Megapixels")
                    KeyPointView(imageName: "display", description: "OLED Display")
                }
                
                HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(product.name)
                                    .font(.title3)
                                    .foregroundColor(.black)
                                
                                Text(product.description ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                    VStack {
                                HStack(spacing: 2) { // Adjust spacing between stars here
                                    ForEach(1...5, id: \.self) { index in
                                        if index <= Int(rating) {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.black)
                                                .font(.title3) // Adjust star size here
                                        } else if index == Int(rating) + 1 && rating.truncatingRemainder(dividingBy: 1) != 0 {
                                            Image(systemName: "star.leadinghalf.filled")
                                                .foregroundColor(.black)
                                                .font(.title3) // Adjust star size here
                                        } else {
                                            Image(systemName: "star")
                                                .foregroundColor(.black)
                                                .font(.title3) // Adjust star size here
                                        }
                                    }
                                }
                                Text("250 Reviews")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                VStack {
                    HStack {
                        if let discountPrice = calculateDiscountedPrice() {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(discountPrice)
                                    .font(.title)
                                    .foregroundColor(.black)
                                
                                Text(formatPrice(product.price))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .strikethrough()
                                    .frame(alignment: .trailing)
                            }
                        } else {
                            Text(formatPrice(product.price))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        ZStack(alignment: .center) {
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    if quantity > 1 {
                                        self.quantity -= 1
                                    }
                                }) {
                                    Image(systemName: "minus")
                                        .font(.title)
                                        .foregroundColor(.black)
                                }
                                
                                Text("\(quantity)")
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                
                                Button(action: {
                                    self.quantity += 1
                                }) {
                                    Image(systemName: "plus")
                                        .font(.title)
                                        .foregroundColor(.black)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .alignmentGuide(HorizontalAlignment.center) { _ in
                                UIScreen.main.bounds.width / 2
                            }
                        }
                        
                        Button(action: {
                            // Add to cart button action
                        }) {
                            Text("Cart")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                    }
                    
                    
                }
            }
            .padding()
        }
    }
    
    private func calculateDiscountedPrice() -> String? {
        guard let discount = product.discount else {
            return nil
        }
        
        let discountedPrice = product.price * (1 - discount)
        return formatPrice(discountedPrice)
    }
    
    private func formatPrice(_ price: Double) -> String {
        let number = NSNumber(value: price)
        return numberFormatter.string(from: number) ?? ""
    }
}

struct KeyPointView: View {
    let imageName: String
    let description: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(.blue)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
