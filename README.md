# 🛒 GoStore

A sample iOS project — Clean Architecture + SwiftUI + MVVM

---

## Overview

**GoStore** is a sample **iOS application** built to demonstrate **best practices** in iOS development, following **Clean Architecture** and **SOLID principles**.  
The app features a **product catalog** with **favorites** and **recently viewed items**, backed by the **FakeStore API** and local **SwiftData persistence**.  
The **presentation layer** is built with **SwiftUI**, following the **MVVM pattern** for a clear and maintainable UI architecture.  
The app uses **Swift Concurrency** for single-request workflows, **Combine** for reactive observation of local data changes, and Swift’s new **Observation framework** to keep SwiftUI views automatically updated with state changes.

---

## Features

### 🛒 Product Catalog
- Browse products from FakeStore API  
- Grid layout with product images, titles, and prices  
- Pull-to-refresh functionality  
- Elegant loading and error states  

### 📦 Product Details
- Detailed product information  
- Star ratings and reviews  
- Add/remove favorites  
- Automatic tracking of viewed products  

### 💛 Favorites Management
- Save favorite products locally  
- Persistent across app launches  
- Real-time synchronization  
- Visual indicators on product cards  

### 🕒 Recently Viewed
- Automatic tracking of viewed products  
- Chronologically ordered history  
- Clear history functionality  
- Favorite status indicators  

---

## Technologies Used

- **SwiftUI** – Declarative UI framework used for the presentation layer.  
- **MVVM** – Architectural pattern separating UI logic from state management for better testability and clarity.  
- **Swift Concurrency (async/await)** – Manages one-time asynchronous operations like API requests.  
- **Combine** – Reactive framework used to observe and propagate local data changes.  
- **Swift Observation** – Native framework (`@Observable`) keeping SwiftUI views automatically updated with state changes.  
- **SwiftData** – Local persistence layer for storing favorite and recently viewed products.  
- **Swinject** – Dependency Injection framework managing modular composition and service registration.  
- **FakeStore API** – Public REST API used as a real backend source for fetching product data.  

---

## Project Structure

```text
GoStore/
├── GoStoreApp/
│   ├── GoStoreApp.swift                        # App entry point
│   │
│   ├── DependencyInjection/
│   │   ├── DIContainer.swift                   # DI abstraction
│   │   ├── SwinjectContainer.swift             # Swinject implementation
│   │   ├── Assembler/
│   │   │   ├── DIAssembly.swift
│   │   │   ├── MainAssembly.swift
│   │   │   └── ProductsAssembly.swift
│   │   └── Factories/
│   │       └── DefaultViewModelFactory.swift
│   │
│   ├── Domain/
│   │   ├── Entities/
│   │   │   ├── Product.swift
│   │   │   ├── ProductSummary.swift
│   │   │   ├── FavoriteProduct.swift
│   │   │   ├── SeenProduct.swift
│   │   │   └── Rating.swift
│   │   │
│   │   ├── RepositoryProtocols/
│   │   │   ├── ProductRepository.swift
│   │   │   ├── FavoriteProductRepository.swift
│   │   │   └── SeenProductRepository.swift
│   │   │
│   │   └── UseCases/
│   │       ├── FetchProductsUseCase.swift
│   │       ├── FetchProductDetailsUseCase.swift
│   │       ├── ObserveFavoriteProductsUseCase.swift
│   │       ├── ToggleFavoriteProductUseCase.swift
│   │       ├── ObserveSeenProductsUseCase.swift
│   │       ├── MarkProductAsSeenUseCase.swift
│   │       ├── ClearSeenProductsHistoryUseCase.swift
│   │       └── Deprecated/
│   │           ├── LoadFavoriteProductsUseCase.swift
│   │           └── LoadSeenProductsUseCase.swift
│   │
│   ├── Data/
│   │   ├── DomainMapping.swift
│   │   │
│   │   ├── Repositories/
│   │   │   ├── FSProductRepository.swift
│   │   │   ├── SDFavoriteProductRepository.swift
│   │   │   └── SDSeenProductRepository.swift
│   │   │
│   │   └── Infrastructure/
│   │       ├── Network/
│   │       │   └── FakeStoreAPI/
│   │       │       ├── FakeStoreAPIClient.swift
│   │       │       ├── FakeStoreProductsEndpoint.swift
│   │       │       ├── FSProduct.swift
│   │       │       └── FSProduct+Mapping.swift
│   │       │
│   │       └── Persistence/
│   │           └── SwiftData/
│   │               ├── SwiftDataStack.swift
│   │               ├── SDProductPersistence.swift
│   │               ├── ModelContext+Convenience.swift
│   │               ├── Models/
│   │               │   ├── SDProduct.swift
│   │               │   ├── SDFavoriteProduct.swift
│   │               │   └── SDSeenProduct.swift
│   │               └── Mappers/
│   │                   ├── SDProduct+Mapping.swift
│   │                   ├── SDFavoriteProduct+Mapping.swift
│   │                   └── SDSeenProduct+Mapping.swift
│   │
│   └── Presentation/
│       ├── ViewModelFactory.swift              # Factory protocol
│       │
│       ├── Tabs/
│       │   ├── ProductCatalogTab.swift
│       │   ├── FavoriteProductsTab.swift
│       │   └── SeenProductsTab.swift
│       │
│       ├── Shared/
│       │   ├── State/
│       │   │   └── AppUIState.swift
│       │   ├── Environment/
│       │   │   └── EnvironmentValues+Factory.swift
│       │   ├── Components/
│       │   │   └── GridView.swift
│       │   └── Modifiers/
│       │       ├── ErrorAlert.swift
│       │       └── LoadingOverlay.swift
│       │
│       └── Features/
│           └── Products/
│               ├── Item/
│               │   ├── ProductItemView.swift
│               │   └── ProductItemViewModel.swift
│               │
│               ├── Catalog/
│               │   ├── ProductCatalogView.swift
│               │   └── ProductCatalogViewModel.swift
│               │
│               ├── Detail/
│               │   ├── ProductDetailView.swift
│               │   └── ProductDetailViewModel.swift
│               │
│               ├── Favorites/
│               │   ├── FavoriteProductsView.swift
│               │   └── FavoriteProductsViewModel.swift
│               │
│               └── RecentlySeen/
│                   ├── SeenProductsView.swift
│                   └── SeenProductsViewModel.swift
│
├── PreviewSupport/
│   └── PreviewViewModelFactory.swift
│
└── Mocks/
    ├── Product+Mocks.swift
    ├── FakeProductRepository.swift
    ├── FakeFavoriteProductRepository.swift
    └── FakeSeenProductRepository.swift
```

---

## AppUIState & Persistence Errors

`AppUIState` is a global **observable state** injected into the SwiftUI environment.  
It subscribes to domain data streams (favorites and recently seen products) but focuses only on **error tracking**.  
It is observed by the **Favorites** and **Recently Seen** tabs through the environment, allowing them to react to persistence errors in real time.  
This design keeps the app **responsive and usable**, even when persistence fails — instead of blocking the UI or showing **unnecessary alerts**, the app simply displays **non-blocking warning badges** to highlight potential **inconsistencies** in the displayed data.

---

## Dependencies

- **Swinject** – Dependency Injection container  
- **Kingfisher** – Async image loading and caching  
- **APIClientCore** – Abstraction layer for building HTTP clients  

---

## Installation

### Prerequisites
- Xcode **15.0+**  
- iOS **17.0+**  
- Swift **5.9+**

---

## Author

**Zine Essafi BEN ALI**
