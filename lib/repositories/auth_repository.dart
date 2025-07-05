import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;
  final SharedPreferences _sharedPreferences;

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyUserEmail = 'user_email';
  static const String _keyAuthToken = 'auth_token';

  AuthRepository({
    required ApiService apiService,
    required SharedPreferences sharedPreferences,
  })  : _apiService = apiService,
        _sharedPreferences = sharedPreferences;

  Future<User> login(String username, String password) async {
    try {
      // Try to login via API first
      final response = await _apiService.login(username, password);
      final user = User.fromJson(response['user']);
      final token = response['token'];

      // Save auth token
      await _sharedPreferences.setString(_keyAuthToken, token);
      _apiService.setAuthToken(token);

      // Save user session data locally
      await _saveUserSession(user);

      return user;
    } catch (e) {
      // If API fails, try offline authentication (for demo purposes)
      // In a real app, you might want to handle this differently
      if (username == 'admin' && password == 'admin') {
        final user = User(
          id: 1,
          username: username,
          email: 'admin@example.com',
          createdAt: DateTime.now(),
        );
        await _saveUserSession(user);
        return user;
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Try to logout via API
      await _apiService.logout();
    } catch (e) {
      // Continue with local logout even if API fails
    }

    // Clear local session data
    await _clearUserSession();
    _apiService.removeAuthToken();
  }

  Future<bool> isLoggedIn() async {
    return _sharedPreferences.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<User?> getCurrentUser() async {
    if (!await isLoggedIn()) {
      return null;
    }

    final userId = _sharedPreferences.getInt(_keyUserId);
    final username = _sharedPreferences.getString(_keyUsername);
    final email = _sharedPreferences.getString(_keyUserEmail);

    if (userId != null && username != null && email != null) {
      return User(
        id: userId,
        username: username,
        email: email,
      );
    }

    return null;
  }

  Future<void> _saveUserSession(User user) async {
    await _sharedPreferences.setBool(_keyIsLoggedIn, true);
    await _sharedPreferences.setInt(_keyUserId, user.id ?? 0);
    await _sharedPreferences.setString(_keyUsername, user.username);
    await _sharedPreferences.setString(_keyUserEmail, user.email);
  }

  Future<void> _clearUserSession() async {
    await _sharedPreferences.remove(_keyIsLoggedIn);
    await _sharedPreferences.remove(_keyUserId);
    await _sharedPreferences.remove(_keyUsername);
    await _sharedPreferences.remove(_keyUserEmail);
    await _sharedPreferences.remove(_keyAuthToken);
  }

  Future<String?> getAuthToken() async {
    return _sharedPreferences.getString(_keyAuthToken);
  }

  Future<void> initializeAuth() async {
    final token = await getAuthToken();
    if (token != null) {
      _apiService.setAuthToken(token);
    }
  }
}