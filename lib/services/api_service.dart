import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';
import '../models/guest_biodata.dart';
import '../models/guest_book.dart';

class ApiService {
  static const String baseUrl = 'https://xyz.com/api'; // Example endpoint
  final Dio _dio;
  final Logger _logger = Logger();

  ApiService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    
    // Add interceptors for logging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => _logger.d(object),
      ),
    );
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      _logger.e('Login error: ${e.message}');
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } on DioException catch (e) {
      _logger.e('Logout error: ${e.message}');
      // Don't throw error for logout as it should work locally too
    }
  }

  // User endpoints
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('/user/profile');
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      _logger.e('Get current user error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Guest Biodata endpoints
  Future<List<GuestBiodata>> getGuestBiodataList() async {
    try {
      final response = await _dio.get('/guest-biodata');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => GuestBiodata.fromJson(json)).toList();
    } on DioException catch (e) {
      _logger.e('Get guest biodata list error: ${e.message}');
      throw _handleError(e);
    }
  }

  Future<GuestBiodata> getGuestBiodata(int id) async {
    try {
      final response = await _dio.get('/guest-biodata/$id');
      return GuestBiodata.fromJson(response.data['data']);
    } on DioException catch (e) {
      _logger.e('Get guest biodata error: ${e.message}');
      throw _handleError(e);
    }
  }

  Future<GuestBiodata> createGuestBiodata(GuestBiodata guestBiodata) async {
    try {
      final response = await _dio.post(
        '/guest-biodata',
        data: guestBiodata.toJson(),
      );
      return GuestBiodata.fromJson(response.data['data']);
    } on DioException catch (e) {
      _logger.e('Create guest biodata error: ${e.message}');
      throw _handleError(e);
    }
  }

  Future<GuestBiodata> updateGuestBiodata(GuestBiodata guestBiodata) async {
    try {
      final response = await _dio.put(
        '/guest-biodata/${guestBiodata.id}',
        data: guestBiodata.toJson(),
      );
      return GuestBiodata.fromJson(response.data['data']);
    } on DioException catch (e) {
      _logger.e('Update guest biodata error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Guest Book endpoints
  Future<List<GuestBook>> getGuestBookList() async {
    try {
      final response = await _dio.get('/guest-books');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => GuestBook.fromJson(json)).toList();
    } on DioException catch (e) {
      _logger.e('Get guest book list error: ${e.message}');
      throw _handleError(e);
    }
  }

  Future<GuestBook> getGuestBook(int id) async {
    try {
      final response = await _dio.get('/guest-books/$id');
      return GuestBook.fromJson(response.data['data']);
    } on DioException catch (e) {
      _logger.e('Get guest book error: ${e.message}');
      throw _handleError(e);
    }
  }

  Future<GuestBook> createGuestBook(GuestBook guestBook) async {
    try {
      final response = await _dio.post(
        '/guest-books',
        data: guestBook.toJson(),
      );
      return GuestBook.fromJson(response.data['data']);
    } on DioException catch (e) {
      _logger.e('Create guest book error: ${e.message}');
      throw _handleError(e);
    }
  }

  Future<GuestBook> updateGuestBook(GuestBook guestBook) async {
    try {
      final response = await _dio.put(
        '/guest-books/${guestBook.id}',
        data: guestBook.toJson(),
      );
      return GuestBook.fromJson(response.data['data']);
    } on DioException catch (e) {
      _logger.e('Update guest book error: ${e.message}');
      throw _handleError(e);
    }
  }

  Future<void> deleteGuestBook(int id) async {
    try {
      await _dio.delete('/guest-books/$id');
    } on DioException catch (e) {
      _logger.e('Delete guest book error: ${e.message}');
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return 'Unauthorized. Please login again.';
        } else if (e.response?.statusCode == 404) {
          return 'Resource not found.';
        } else if (e.response?.statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return e.response?.data['message'] ?? 'An error occurred.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}