# Laravel Contact Manager with Docker

A modern contact management system built with Laravel 11, featuring Docker containerization, authentication, and comprehensive testing.

## 🚀 Features

- **Complete CRUD Operations** for contacts
- **User Authentication** with session management
- **Search & Filter** functionality
- **Responsive Bootstrap 5 UI**
- **Docker containerization** (PHP 8.3 FPM, Nginx, MariaDB, phpMyAdmin)
- **Comprehensive testing** with PHPUnit
- **Admin user factory** with predefined credentials

## 🐳 Docker Stack

- **PHP 8.3 FPM** - Application server
- **Nginx Alpine** - Web server  
- **MariaDB Latest** - Database
- **phpMyAdmin** - Database management

## 📋 Prerequisites

- Docker & Docker Compose
- Git

## 🛠️ Quick Setup

### 1. Clone & Build

```bash
git clone <repository-url>
cd laravel-contact-manager
docker-compose up -d --build
```

### 2. Install Dependencies

```bash
docker-compose exec app composer install
```

### 3. Setup Application

```bash
# Generate application key
docker-compose exec app php artisan key:generate

# Run migrations
docker-compose exec app php artisan migrate

# Seed admin user
docker-compose exec app php artisan db:seed --class=AdminUserSeeder
```

## 🌐 Access Points

- **Application**: http://localhost:8000
- **phpMyAdmin**: http://localhost:8080
  - Server: `db`
  - Username: `laravel`
  - Password: `laravel`

## 🔐 Default Login Credentials

- **Email**: admin@admin.com
- **Password**: admin

## 📁 Project Structure

```
├── app/
│   ├── Http/Controllers/
│   │   ├── AuthController.php      # Authentication logic
│   │   └── ContactController.php   # Contact CRUD operations
│   └── Models/
│       ├── Contact.php             # Contact model with search scope
│       └── User.php                # User model
├── database/
│   ├── factories/
│   │   └── UserFactory.php         # User factory with admin method
│   ├── migrations/
│   │   └── create_contacts_table.php
│   └── seeders/
│       └── AdminUserSeeder.php     # Creates admin user
├── resources/views/
│   ├── auth/
│   │   └── login.blade.php         # Beautiful login form
│   ├── contacts/                   # Contact management views
│   └── layouts/
│       └── app.blade.php           # Main layout with session info
├── tests/Feature/
│   └── AuthenticationTest.php      # Comprehensive auth tests
├── docker/                         # Docker configuration
├── docker-compose.yml
└── Dockerfile
```

## 🧪 Testing

Run the comprehensive test suite:

```bash
# Run all tests
docker-compose exec app php artisan test

# Run specific test file
docker-compose exec app php artisan test tests/Feature/AuthenticationTest.php

# Run with coverage
docker-compose exec app php artisan test --coverage
```

### Test Coverage

The `AuthenticationTest` class includes:

- ✅ Login page accessibility
- ✅ Admin user factory creation
- ✅ Successful authentication with correct credentials
- ✅ Session facade usage verification
- ✅ Failed authentication handling
- ✅ Logout functionality
- ✅ Route protection middleware
- ✅ Session persistence
- ✅ Remember me functionality

## 📊 Database Schema

### Contacts Table
```sql
CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    company VARCHAR(150),
    job_title VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔧 Development Commands

```bash
# Start containers
docker-compose up -d

# Stop containers
docker-compose down

# View logs
docker-compose logs -f app

# Access application container
docker-compose exec app bash

# Run artisan commands
docker-compose exec app php artisan <command>

# Install new packages
docker-compose exec app composer require <package>
```

## 🎨 UI Features

- **Gradient design** with modern aesthetics
- **Responsive layout** for all screen sizes
- **Card-based contact display** with hover effects
- **Search functionality** with real-time filtering
- **Flash messages** for user feedback
- **Session information display** in sidebar
- **Quick action buttons** (call, email, map)

## 🔐 Authentication Features

- **Session-based authentication** using Laravel's built-in system
- **Custom session data** storage using Session facade
- **Remember me** functionality
- **Route protection** with middleware
- **Beautiful login form** with demo credentials display
- **Logout functionality** with session cleanup

## 📝 API Endpoints

### Authentication
- `GET /login` - Show login form
- `POST /login` - Authenticate user
- `POST /logout` - Logout user

### Contacts (Protected)
- `GET /contacts` - List all contacts
- `GET /contacts/create` - Show create form
- `POST /contacts` - Store new contact
- `GET /contacts/{id}` - Show contact details
- `GET /contacts/{id}/edit` - Show edit form
- `PUT /contacts/{id}` - Update contact
- `DELETE /contacts/{id}` - Delete contact

## 🛡️ Security Features

- CSRF protection on all forms
- Input validation and sanitization
- SQL injection prevention with Eloquent ORM
- Session regeneration on login
- Password hashing with bcrypt
- Route protection with authentication middleware

## 🚀 Production Deployment

For production deployment:

1. Update `.env` with production values
2. Set `APP_ENV=production`
3. Set `APP_DEBUG=false`
4. Use proper SSL certificates
5. Configure proper database credentials
6. Set up proper logging
7. Enable caching and optimization

## 📄 License

This project is open-sourced software licensed under the [MIT license](LICENSE).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📞 Support

For support and questions, please open an issue in the repository.
