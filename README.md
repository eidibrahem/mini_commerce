# Mini Commerce Flutter App

A modern e-commerce Flutter application built with clean architecture principles, Firebase integration, and comprehensive user features.

## 🏗️ Project Structure

The project follows a clean architecture pattern with feature-based organization:

```
lib/
│
├── app/                          # App-level configuration
│   ├── di/                      # Dependency Injection
│   │   └── injector.dart        # DI container setup
│   ├── router.dart              # App routing configuration
│   ├── theme.dart               # App theme and styling
│   └── app.dart                 # Root app widget
│
├── core/                        # Core functionality
│   ├── config/                  # App configuration
│   │   └── app_config.dart      # Centralized app configuration
│   ├── error/                   # Error handling
│   │   └── failures.dart        # Failure classes
│   ├── localization/            # Internationalization
│   │   ├── app_strings.dart     # String management
│   │   ├── language_provider.dart # Language switching
│   │   └── l10n/                # Localization files
│   ├── network/                 # Network layer
│   ├── services/                # Core services
│   │   ├── cache_helper.dart    # Local storage
│   │   ├── firebase_service.dart # Firebase operations
│   │   └── stripe_service.dart  # Payment processing
│   ├── usecase/                 # Use case base classes
│   │   └── usecase.dart         # Base UseCase interface
│   ├── utils/                   # Utility classes
│   │   └── validators.dart      # Input validation
│   └── constants.dart           # App constants
│
├── features/                    # Feature modules
│   ├── auth/                    # Authentication feature
│   │   ├── domain/              # Business logic layer
│   │   │   ├── entities/        # Business entities
│   │   │   ├── repositories/    # Repository interfaces
│   │   │   └── usecases/        # Business use cases
│   │   ├── data/                # Data layer
│   │   │   ├── datasources/     # Data sources
│   │   │   ├── models/          # Data models
│   │   │   └── repositories/    # Repository implementations
│   │   └── presentation/        # UI layer
│   │       ├── providers/       # State management
│   │       └── pages/           # UI pages
│   │
│   ├── products/                # Products feature
│   │   ├── domain/              # Business logic layer
│   │   ├── data/                # Data layer
│   │   └── presentation/        # UI layer
│   │
│   ├── cart/                    # Shopping cart feature
│   │   ├── domain/              # Business logic layer
│   │   ├── data/                # Data layer
│   │   └── presentation/        # UI layer
│   │
│   ├── profile/                 # User profile feature
│   │   ├── domain/              # Business logic layer
│   │   ├── data/                # Data layer
│   │   └── presentation/        # UI layer
│   │
│   └── map/                     # Location services feature
│       └── presentation/        # UI layer
│           └── pages/           # Map pages
│
├── firebase_options.dart         # FlutterFire configuration
└── main.dart                    # App entry point
```

## 🚀 Features

### ✅ **Authentication & User Management**
- **Email/Password Authentication**: Secure login and registration
- **Google Sign-In Integration**: One-tap Google authentication
- **User Registration & Login**: Complete user onboarding
- **Password Reset**: Email-based password recovery
- **Profile Management**: Comprehensive user profile system
- **Secure Logout**: Complete data cleanup and session termination

### ✅ **Product Management**
- **Product Catalog**: Organized product listings with categories
- **Advanced Search**: Real-time product search and filtering
- **Product Details**: Rich product information and images
- **Category System**: Organized product browsing
- **Product Cards**: Beautiful, responsive product displays

### ✅ **Shopping Cart System**
- **Add/Remove Products**: Seamless cart management
- **Quantity Control**: Easy quantity adjustments
- **Cart Persistence**: Local storage for cart items
- **Real-time Updates**: Live cart synchronization
- **Checkout Process**: Streamlined purchase flow

### ✅ **User Profile & Settings**
- **Personal Information**: Name, email, phone management
- **Address Management**: Multiple address support
- **Profile Picture**: Image upload with cropping
- **Account Settings**: Comprehensive user preferences
- **Data Export**: User data management

### ✅ **Advanced Features**
- **Profile Image Cropping**: Professional image editing with square aspect ratio
- **Firebase Storage**: Secure image storage and management
- **Google Maps Integration**: Location services and mapping
- **In-App Review System**: Native app rating functionality
- **Multi-language Support**: English and Arabic localization
- **Responsive Design**: Works on all device sizes

### 🔄 **In Progress**
- **Payment Integration**: Stripe payment processing
- **Push Notifications**: Real-time user engagement
- **Offline Support**: Data synchronization
- **Advanced Analytics**: User behavior tracking

## 🛠️ Technology Stack

### **Frontend & Framework**
- **Flutter**: Latest stable version with Material Design 3
- **Dart**: Modern, type-safe programming language
- **Provider**: State management solution
- **GetIt**: Dependency injection container

### **Backend & Services**
- **Firebase**: Complete backend-as-a-service
  - **Authentication**: User management and security
  - **Firestore**: NoSQL database
  - **Storage**: File and image storage
  - **Messaging**: Push notifications
- **Stripe**: Payment processing integration

### **Development & Tools**
- **Clean Architecture**: Scalable, maintainable code structure
- **Git**: Version control and collaboration
- **Flutter DevTools**: Development and debugging tools
- **VS Code/Android Studio**: IDE support

## 📱 Getting Started

### Prerequisites
- **Flutter SDK**: 3.7.2 or higher
- **Dart SDK**: Latest stable version
- **Android Studio / VS Code**: With Flutter extensions
- **Device/Emulator**: Android 5.0+ or iOS 12.0+

### Installation

1. **Clone the repository**:
```bash
git clone https://github.com/yourusername/mini_commerce.git
cd mini_commerce
```

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Configure Firebase**:
   - Create a Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective platform folders

4. **Run the app**:
```bash
flutter run
```

## 🏗️ Architecture Principles

### **Clean Architecture**
The app follows clean architecture principles with clear separation of concerns:

- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Data operations, models, and repositories
- **Presentation Layer**: UI, state management, and user interactions

### **Dependency Injection**
Uses GetIt for dependency injection ensuring:
- Loose coupling between components
- Easy testing and mocking
- Scalable architecture

### **State Management**
Provider pattern for reactive state management:
- Predictable state updates
- Efficient UI rebuilding
- Easy debugging and testing

## 📁 Key Files & Configuration

### **Core Files**
- `lib/main.dart` - App entry point and Firebase initialization
- `lib/app/app.dart` - Main app widget and configuration
- `lib/app/di/injector.dart` - Dependency injection setup
- `lib/app/router.dart` - Navigation and routing configuration
- `lib/app/theme.dart` - App theming and styling
- `lib/core/config/app_config.dart` - Centralized configuration

### **Feature Files**
- `lib/features/auth/` - Authentication system
- `lib/features/products/` - Product management
- `lib/features/cart/` - Shopping cart functionality
- `lib/features/profile/` - User profile management
- `lib/features/map/` - Location services

### **Configuration Files**
- `android/app/src/main/AndroidManifest.xml` - Android permissions and config
- `ios/Runner/Info.plist` - iOS permissions and configuration
- `firebase_options.dart` - Firebase configuration
- `pubspec.yaml` - Dependencies and project configuration

## 🔧 Configuration & Setup

### **Firebase Setup**
1. **Project Creation**: Create Firebase project in console
2. **Authentication**: Enable Email/Password and Google Sign-In
3. **Firestore**: Set up database rules and collections
4. **Storage**: Configure storage rules for images
5. **Configuration**: Download and add platform-specific config files

### **API Keys & Configuration**
- **Google Maps API**: `AIzaSyC-WYusA4tHyCV0HsD8dfVG-spfQMgC05U`
- **Stripe Keys**: Configure in `lib/core/config/app_config.dart`
- **Firebase Config**: Auto-generated in `firebase_options.dart`

### **Environment Variables**
- Create `.env` file for sensitive configuration
- Add to `.gitignore` for security
- Use `flutter_dotenv` for environment management

## 🧪 Testing & Quality Assurance

### **Testing Strategy**
```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/

# Coverage report
flutter test --coverage
```

### **Code Quality**
- **Flutter Lints**: Enforced code standards
- **Analysis Options**: Custom linting rules
- **Pre-commit Hooks**: Automated quality checks
- **CI/CD Pipeline**: Automated testing and deployment

## 📦 Dependencies & Packages

### **Core Dependencies**
- `flutter_localizations` - Internationalization support
- `provider` - State management
- `get_it` - Dependency injection
- `firebase_core` - Firebase initialization
- `firebase_auth` - User authentication
- `cloud_firestore` - Database operations
- `firebase_storage` - File storage

### **UI & UX Packages**
- `image_picker` - Image selection
- `image_cropper` - Image editing and cropping
- `google_maps_flutter` - Maps integration
- `geolocator` - Location services
- `in_app_review` - App rating system

### **Payment & Services**
- `flutter_stripe` - Payment processing
- `google_sign_in` - Google authentication
- `cached_network_image` - Image caching
- `shared_preferences` - Local data storage

## 🚧 Development Status

### ✅ **Completed Features**
- [x] **Project Architecture**: Clean architecture implementation
- [x] **Authentication System**: Complete user management
- [x] **Product Management**: Catalog, search, and filtering
- [x] **Shopping Cart**: Full cart functionality
- [x] **User Profile**: Comprehensive profile management
- [x] **Image Management**: Upload, cropping, and storage
- [x] **Google Maps**: Location services integration
- [x] **In-App Review**: Native rating system
- [x] **Multi-language**: English and Arabic support
- [x] **Firebase Integration**: Complete backend setup
- [x] **Responsive Design**: All device sizes supported

### 🔄 **In Progress**
- [ ] **Payment Processing**: Stripe integration
- [ ] **Push Notifications**: User engagement
- [ ] **Offline Support**: Data synchronization
- [ ] **Advanced Analytics**: User behavior tracking

### 📋 **Planned Features**
- [ ] **Admin Dashboard**: Store management
- [ ] **Order Tracking**: Real-time delivery updates
- [ ] **Wishlist**: User favorites management
- [ ] **Social Features**: User reviews and ratings
- [ ] **Advanced Search**: AI-powered product discovery

## 🤝 Contributing

We welcome contributions! Here's how to get started:

### **Development Setup**
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes following our coding standards
4. Add tests for new functionality
5. Ensure all tests pass: `flutter test`
6. Submit a pull request

### **Coding Standards**
- Follow Flutter best practices
- Use meaningful commit messages
- Add comprehensive documentation
- Include tests for new features
- Follow the existing code style

### **Issue Reporting**
- Use the issue template
- Provide detailed reproduction steps
- Include device and OS information
- Attach relevant logs and screenshots

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🆘 Support & Community

### **Getting Help**
- **GitHub Issues**: Report bugs and request features
- **Documentation**: Comprehensive code documentation
- **Community**: Join our developer community
- **Email**: Contact the development team

### **Resources**
- **Flutter Documentation**: [flutter.dev](https://flutter.dev)
- **Firebase Docs**: [firebase.google.com](https://firebase.google.com)
- **Clean Architecture**: [blog.cleancoder.com](https://blog.cleancoder.com)

## 🔮 Roadmap & Future Plans

### **Short Term (Next 3 months)**
- [ ] Complete Stripe payment integration
- [ ] Implement push notifications
- [ ] Add offline data support
- [ ] Enhance user analytics

### **Medium Term (3-6 months)**
- [ ] Admin dashboard development
- [ ] Advanced order management
- [ ] User review system
- [ ] Performance optimization

### **Long Term (6+ months)**
- [ ] AI-powered recommendations
- [ ] Advanced analytics dashboard
- [ ] Multi-store support
- [ ] Enterprise features

## 📊 Performance & Metrics

### **Current Performance**
- **App Size**: Optimized for minimal download size
- **Startup Time**: Fast app initialization
- **Memory Usage**: Efficient resource management
- **Battery Life**: Optimized for mobile devices

### **Monitoring & Analytics**
- **Crash Reporting**: Firebase Crashlytics integration
- **Performance Monitoring**: Firebase Performance
- **User Analytics**: Firebase Analytics
- **Error Tracking**: Comprehensive error logging

---

## 🌟 **Recent Updates**

### **v1.2.0 - Profile & Image Management**
- ✅ Profile image cropping with square aspect ratio
- ✅ Firebase Storage integration for images
- ✅ Automatic image cleanup and optimization
- ✅ Enhanced user profile management

### **v1.1.0 - Maps & Location Services**
- ✅ Google Maps integration
- ✅ Current location detection
- ✅ Location permissions handling
- ✅ Cross-platform map support

### **v1.0.0 - Core Features**
- ✅ Complete authentication system
- ✅ Product catalog and management
- ✅ Shopping cart functionality
- ✅ Multi-language support

---

**Built with ❤️ using Flutter, Clean Architecture, and Firebase**

*Last updated: December 2024*
