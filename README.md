# Product Explorer 🛍️

A modern, production-ready Flutter application for browsing and exploring products using the DummyJSON API. Built with Clean Architecture, featuring smooth animations, offline support, and industry-standard best practices.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 Features

### Core Functionality
- **Paginated Product List** - Infinite scroll with 10 items per batch
- **Smart Search** - Debounced search with 500ms delay for optimal performance
- **Product Details** - Comprehensive view with images, description, price, and ratings
- **Offline Support** - Local caching with automatic fallback
- **Network Detection** - Graceful handling of connectivity issues

### UI/UX Excellence
- **Smooth Animations** - Staggered list animations, page transitions, and micro-interactions
- **Hero Transitions** - Seamless image transitions between screens
- **Image Carousel** - Swipeable product images with indicators
- **Pull to Refresh** - Intuitive refresh mechanism
- **Dark Theme** - Modern black and white design with Inter font
- **Responsive Design** - Optimized for all screen sizes

### Technical Highlights
- **Clean Architecture** - Separation of concerns with Domain, Data, and Presentation layers
- **MVVM Pattern** - ViewModel-based state management with Provider
- **Dependency Injection** - GetIt for loose coupling
- **Error Handling** - User-friendly error messages with retry options
- **Fast Startup** - Optimized initialization with splash screen
- **Performance** - Efficient scrolling with optimized animations

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart       # Centralized color definitions
│   │   ├── app_endpoints.dart    # API endpoints
│   │   └── app_strings.dart      # String constants
│   ├── di/
│   │   └── injection_container.dart  # Dependency injection setup
│   ├── services/
│   │   ├── cache_service.dart    # Local storage service
│   │   └── connectivity_service.dart  # Network detection
│   ├── theme/
│   │   └── app_theme.dart        # App theme configuration
│   └── utils/
│       └── page_transitions.dart # Custom page transitions
├── data/
│   ├── datasources/
│   │   ├── product_local_data_source.dart   # Cache operations
│   │   └── product_remote_data_source.dart  # API calls
│   ├── models/
│   │   ├── product_model.dart               # Product data model
│   │   └── product_list_response_model.dart # Response model
│   └── repositories/
│       └── product_repository_impl.dart     # Repository implementation
├── domain/
│   ├── entities/
│   │   ├── product.dart                     # Product entity
│   │   └── product_list_response.dart       # Response entity
│   ├── repositories/
│   │   └── product_repository.dart          # Repository interface
│   └── use_cases/
│       ├── get_products_use_case.dart       # Fetch products
│       └── get_product_by_id_use_case.dart  # Fetch single product
└── presentation/
    ├── screens/
    │   ├── splash_screen.dart               # Splash screen
    │   ├── product_list_screen.dart         # Product list
    │   └── product_detail_screen.dart       # Product details
    ├── viewmodels/
    │   ├── product_list_view_model.dart     # List state management
    │   └── product_detail_view_model.dart   # Detail state management
    └── widgets/
        ├── animated_product_card.dart       # Animated product card
        ├── animated_content_section.dart    # Content animations
        ├── app_text_field.dart              # Search field
        └── app_error_widget.dart            # Error display
```

## 📦 Dependencies

### Core
- **flutter_sdk** - Flutter framework
- **provider** (^6.1.1) - State management
- **get_it** (^7.6.4) - Dependency injection
- **equatable** (^2.0.5) - Value equality

### Networking & Data
- **dio** (^5.4.0) - HTTP client
- **pretty_dio_logger** (^1.3.1) - API logging
- **connectivity_plus** (^5.0.2) - Network detection
- **shared_preferences** (^2.2.2) - Local storage
- **json_annotation** (^4.9.0) - JSON serialization

### UI
- **cached_network_image** (^3.3.0) - Image caching

### Dev Dependencies
- **build_runner** (^2.4.7) - Code generation
- **json_serializable** (^6.7.1) - JSON code generation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code / Cursor
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/pawan14325/Product-Explorer.git
   cd Product-Explorer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK**
```bash
flutter build apk --release
```

**Android App Bundle**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## 🎨 Design Patterns

### Clean Architecture
- **Domain Layer** - Business logic and entities
- **Data Layer** - Data sources and repositories
- **Presentation Layer** - UI and state management

### MVVM (Model-View-ViewModel)
- **Model** - Data entities and models
- **View** - UI components (Screens & Widgets)
- **ViewModel** - Business logic and state (Provider)

### Repository Pattern
- Abstract data sources
- Centralized data access
- Easy testing and mocking

## 🔧 Configuration

### API Endpoints
All endpoints are configured in `lib/core/constants/app_endpoints.dart`:
- Base URL: `https://dummyjson.com`
- Products: `/products`
- Search: `/products/search`
- Product by ID: `/products/{id}`

### Theme
Theme configuration is in `lib/core/theme/app_theme.dart`:
- Dark theme with black and white colors
- Inter font family
- Material Design 3

### Colors
All colors are defined in `lib/core/constants/app_colors.dart` for easy customization.

## 📱 Screenshots

*Add your app screenshots here*

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

## 🔍 Code Quality

- **Clean Architecture** - Separation of concerns
- **SOLID Principles** - Maintainable code
- **DRY (Don't Repeat Yourself)** - Reusable components
- **Type Safety** - Strong typing with Dart
- **Error Handling** - Comprehensive error management
- **Code Documentation** - Clear comments and structure

## 🚀 Performance Optimizations

- **Lazy Loading** - Load items as needed
- **Image Caching** - Cached network images
- **Debounced Search** - Reduced API calls
- **Optimized Animations** - Smooth 60 FPS
- **Fast Startup** - Async initialization
- **Efficient Scrolling** - Optimized list rendering

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Pawan Singh**
- GitHub: [@pawan14325](https://github.com/pawan14325)

## 🙏 Acknowledgments

- [DummyJSON](https://dummyjson.com) - Free fake REST API
- [Flutter](https://flutter.dev) - UI framework
- [Provider](https://pub.dev/packages/provider) - State management
- [Dio](https://pub.dev/packages/dio) - HTTP client

## 📞 Support

For support, email your-pawan921@gmail.com or open an issue in the repository.

---

**Made with ❤️ using Flutter**
