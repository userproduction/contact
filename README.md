# Flutter Guest Book Application

A comprehensive Guest Book application built with Flutter using the latest technologies and best practices.

## 🚀 Features

### Core Functionality
- **Authentication System**: Session-based authentication with SharedPreferences
- **Dual Data Storage**: SQLite for offline data, API endpoints for online data
- **Repository Pattern**: Clean architecture with data abstraction
- **BLoC State Management**: Reactive state management with flutter_bloc
- **Offline-First**: Works seamlessly offline with sync capabilities

### Screen Hierarchy
1. **Login Screen**: Internal authentication (no registration needed)
2. **Main Screen**: Two-tab interface (Offline/Online data lists)
3. **Detail Guest Screen**: Complete guest biodata display
4. **Add Guest Book Screen**: Form to create new entries
5. **Guest Biodata Screen**: Current user's biodata
6. **Detailed Guest Information Screen**: Complete user information

### Technical Features
- **Repository Pattern**: Clean data layer abstraction
- **BLoC Architecture**: Predictable state management
- **SQLite Integration**: Local database with custom schema
- **API Integration**: RESTful API communication with Dio
- **Session Management**: SharedPreferences for user sessions
- **Error Handling**: Comprehensive error states and messaging
- **Sync Capabilities**: Bidirectional data synchronization
- **Modern UI**: Material Design 3 with beautiful animations

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                    # App entry point
├── app.dart                     # App configuration and routing
├── models/                      # Data models
│   ├── user.dart
│   ├── guest_biodata.dart
│   └── guest_book.dart
├── services/                    # Core services
│   ├── database_service.dart    # SQLite operations
│   └── api_service.dart         # HTTP/API operations
├── repositories/                # Repository pattern
│   ├── auth_repository.dart
│   ├── guest_repository.dart
│   └── guest_book_repository.dart
├── bloc/                        # BLoC state management
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── guest/
│   │   ├── guest_bloc.dart
│   │   ├── guest_event.dart
│   │   └── guest_state.dart
│   └── guest_book/
│       ├── guest_book_bloc.dart
│       ├── guest_book_event.dart
│       └── guest_book_state.dart
├── screens/                     # UI screens
│   ├── login_screen.dart
│   ├── main_screen.dart
│   ├── add_guest_book_screen.dart
│   ├── guest_detail_screen.dart
│   ├── guest_biodata_screen.dart
│   └── detailed_guest_info_screen.dart
└── widgets/                     # Reusable widgets
    └── guest_book_list.dart
```

## �️ Database Schema

### SQLite Tables
```sql
-- Users table
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    created_at INTEGER
);

-- Guest biodata table
CREATE TABLE guess_biodata (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    users_id INTEGER NOT NULL,
    full_name TEXT NOT NULL,
    address TEXT,
    phone_number TEXT,
    email TEXT,
    created_at INTEGER,
    FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Guest books table
CREATE TABLE guess_books (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    guess_id INTEGER NOT NULL,
    message TEXT NOT NULL,
    created_by INTEGER,
    created_at INTEGER,
    FOREIGN KEY (guess_id) REFERENCES guess_biodata(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);
```

## 🔧 Tech Stack

### Core Dependencies
- **flutter**: Latest stable version
- **flutter_bloc**: ^8.1.3 - State management
- **equatable**: ^2.0.5 - Value equality
- **sqflite**: ^2.3.0 - SQLite database
- **dio**: ^5.3.2 - HTTP client
- **shared_preferences**: ^2.2.2 - Local storage
- **go_router**: ^12.1.1 - Navigation
- **flutter_form_builder**: ^9.1.1 - Form building
- **form_builder_validators**: ^9.1.0 - Form validation
- **intl**: ^0.18.1 - Internationalization
- **logger**: ^2.0.2+1 - Logging

### Development Dependencies
- **flutter_test**: Testing framework
- **flutter_lints**: ^3.0.0 - Linting rules
- **build_runner**: ^2.4.7 - Code generation
- **mockito**: ^5.4.2 - Mocking for tests

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (included with Flutter)
- Android Studio or VS Code
- Android/iOS emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd guest_book_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Demo Credentials
- **Username**: admin
- **Password**: admin

## 🏛️ Architecture Patterns

### Repository Pattern
The app implements the Repository pattern to abstract data sources:
- **AuthRepository**: Handles authentication with both API and local storage
- **GuestRepository**: Manages guest biodata with sync capabilities
- **GuestBookRepository**: Handles guest book entries with offline/online support

### BLoC Pattern
State management using BLoC (Business Logic Component):
- **AuthBloc**: Authentication state management
- **GuestBloc**: Guest biodata operations
- **GuestBookBloc**: Guest book entries management

### Service Layer
- **DatabaseService**: SQLite operations with custom schema
- **ApiService**: HTTP operations with error handling and retry logic

## � Features Detail

### Authentication
- Session-based authentication using SharedPreferences
- Automatic token management for API calls
- Offline authentication fallback
- Secure logout with data cleanup

### Data Management
- **Offline-First**: All data stored locally in SQLite
- **Online Sync**: Bidirectional synchronization with API
- **Conflict Resolution**: Last-write-wins strategy
- **Error Handling**: Graceful fallback to offline data

### UI/UX
- **Material Design 3**: Modern, consistent design
- **Responsive Layout**: Works on various screen sizes
- **Loading States**: Clear feedback during operations
- **Error States**: User-friendly error messages
- **Empty States**: Helpful guidance when no data

### Navigation
- **Go Router**: Declarative routing with deep linking
- **Protected Routes**: Authentication-based navigation
- **Nested Navigation**: Hierarchical screen structure

## 🔄 Sync Strategy

### Data Synchronization
1. **To Online**: Upload local changes to API
2. **To Offline**: Download online data to local storage
3. **Full Sync**: Bidirectional sync with conflict resolution

### Conflict Resolution
- Last-write-wins for simplicity
- Timestamps used for comparison
- Manual conflict resolution UI (future enhancement)

## 🧪 Testing Strategy

### Unit Tests
- Repository pattern testing
- BLoC testing with mock repositories
- Service layer testing

### Integration Tests
- Database operations
- API integration
- Full user flows

### Widget Tests
- Screen rendering
- User interactions
- State changes

## 📊 Performance Optimizations

### Database
- Indexed columns for faster queries
- Connection pooling
- Lazy loading for large datasets

### API
- Request/response caching
- Retry mechanisms with exponential backoff
- Connection timeout handling

### UI
- ListView.builder for large lists
- Image caching
- Lazy loading of screens

## 🔒 Security Considerations

### Data Protection
- SQLite encryption (can be added)
- API token management
- Secure session handling

### Network Security
- HTTPS enforcement
- Certificate pinning (recommended for production)
- Request signing (can be implemented)

## 🚀 Deployment

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## � Future Enhancements

### Features
- Push notifications for new entries
- Image upload for guest photos
- Advanced search and filtering
- Export data functionality
- Multi-language support

### Technical
- GraphQL API integration
- Real-time sync with WebSockets
- Offline-first with eventual consistency
- Biometric authentication
- Background sync service

## 🐛 Known Issues

1. **API Endpoint**: Currently points to example domain (https://xyz.com)
2. **Image Handling**: Not yet implemented
3. **Pagination**: Large datasets may impact performance
4. **Sync Conflicts**: Basic resolution strategy implemented

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📞 Support

For support or questions, please open an issue in the GitHub repository.

## 📝 Changelog

### Version 1.0.0
- Initial release with core functionality
- Authentication system
- Offline/online data management
- BLoC state management
- Repository pattern implementation
- Beautiful Material Design UI

---

**Note**: This is a demonstration project showcasing Flutter best practices, BLoC pattern, Repository pattern, and offline-first architecture. The API endpoints need to be configured for production use.
