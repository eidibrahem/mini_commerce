# Mini Commerce Flutter App

A modern e-commerce Flutter application built with clean architecture principles and best practices.

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
│   ├── error/                   # Error handling
│   │   └── failures.dart        # Failure classes
│   ├── usecase/                 # Use case base classes
│   │   └── usecase.dart         # Base UseCase interface
│   ├── utils/                   # Utility classes
│   │   └── result.dart          # Result/Either helper
│   └── constants.dart           # App constants (colors, keys, etc.)
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
│   └── profile/                 # User profile feature
│       ├── domain/              # Business logic layer
│       ├── data/                # Data layer
│       └── presentation/        # UI layer
│
├── firebase_options.dart         # FlutterFire configuration
└── main.dart                    # App entry point
```

## 🚀 Features

### Authentication
- Email/password authentication
- Google Sign-In integration
- User registration and login
- Password reset functionality
- Profile management

### Products
- Product catalog with categories
- Product search and filtering
- Product details and images
- Rating and review system

### Shopping Cart
- Add/remove products
- Quantity management
- Cart persistence
- Checkout process (coming soon)

### User Profile
- Personal information management
- Address management
- Profile picture upload
- Account settings

## 🛠️ Technology Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Dependency Injection**: GetIt
- **Architecture**: Clean Architecture
- **Backend**: Firebase (planned)
- **Database**: Cloud Firestore (planned)

## 📱 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/mini_commerce.git
cd mini_commerce
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🏗️ Architecture Principles

### Clean Architecture
The app follows clean architecture principles with clear separation of concerns:

- **Domain Layer**: Contains business logic, entities, and use cases
- **Data Layer**: Handles data operations, models, and repositories
- **Presentation Layer**: Manages UI, state, and user interactions

### Dependency Injection
Uses GetIt for dependency injection to ensure loose coupling and testability.

### State Management
Provider pattern for state management, making the app reactive and maintainable.

## 📁 Key Files

- `lib/main.dart` - App entry point
- `lib/app/app.dart` - Main app widget
- `lib/app/di/injector.dart` - Dependency injection setup
- `lib/app/router.dart` - Navigation configuration
- `lib/app/theme.dart` - App theming
- `lib/core/constants.dart` - App-wide constants
- `lib/core/utils/result.dart` - Result wrapper for error handling

## 🔧 Configuration

### Environment Setup
1. Configure Firebase project (when ready)
2. Update API endpoints in `lib/core/constants.dart`
3. Configure authentication providers

### Theme Customization
Modify `lib/app/theme.dart` to customize:
- Color scheme
- Typography
- Component styles
- Dark/light theme variants

## 🧪 Testing

The project structure supports comprehensive testing:

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

## 📦 Dependencies

Key dependencies include:
- `provider` - State management
- `get_it` - Dependency injection
- `firebase_core` - Firebase integration
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `image_picker` - Image selection
- `google_sign_in` - Google authentication

## 🚧 Development Status

- [x] Project structure setup
- [x] Core architecture implementation
- [x] Authentication feature (UI complete)
- [x] Products feature (UI complete)
- [x] Cart feature (UI complete)
- [x] Profile feature (UI complete)
- [ ] Firebase integration
- [ ] API implementation
- [ ] State management integration
- [ ] Testing implementation
- [ ] Production deployment

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔮 Roadmap

- [ ] Payment integration (Stripe)
- [ ] Push notifications
- [ ] Offline support
- [ ] Multi-language support
- [ ] Advanced analytics
- [ ] Admin dashboard
- [ ] Mobile app deployment

---

Built with ❤️ using Flutter and Clean Architecture principles.
