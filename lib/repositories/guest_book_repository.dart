import '../models/guest_book.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class GuestBookRepository {
  final ApiService _apiService;
  final DatabaseService _databaseService;

  GuestBookRepository({
    required ApiService apiService,
    required DatabaseService databaseService,
  })  : _apiService = apiService,
        _databaseService = databaseService;

  // Get all guest books (offline)
  Future<List<GuestBook>> getOfflineGuestBooks() async {
    return await _databaseService.getAllGuestBooks();
  }

  // Get all guest books (online)
  Future<List<GuestBook>> getOnlineGuestBooks() async {
    try {
      return await _apiService.getGuestBookList();
    } catch (e) {
      // Fallback to offline data if online fails
      return await getOfflineGuestBooks();
    }
  }

  // Get specific guest book by ID
  Future<GuestBook?> getGuestBook(int id, {bool fromOnline = false}) async {
    if (fromOnline) {
      try {
        return await _apiService.getGuestBook(id);
      } catch (e) {
        // Fallback to offline data
        return await _databaseService.getGuestBookById(id);
      }
    } else {
      return await _databaseService.getGuestBookById(id);
    }
  }

  // Create new guest book (sync to both offline and online)
  Future<GuestBook> createGuestBook(GuestBook guestBook) async {
    // Save to offline database first
    final guestBookWithTimestamp = guestBook.copyWith(
      createdAt: DateTime.now(),
    );
    
    final localId = await _databaseService.insertGuestBook(guestBookWithTimestamp);
    final localGuestBook = guestBookWithTimestamp.copyWith(id: localId);

    // Try to sync to online
    try {
      final onlineGuestBook = await _apiService.createGuestBook(localGuestBook);
      
      // Update local data with online ID if different
      if (onlineGuestBook.id != localId) {
        await _databaseService.updateGuestBook(
          localGuestBook.copyWith(id: onlineGuestBook.id),
        );
      }
      
      return onlineGuestBook;
    } catch (e) {
      // Return local data if online sync fails
      return localGuestBook;
    }
  }

  // Update guest book (sync to both offline and online)
  Future<GuestBook> updateGuestBook(GuestBook guestBook) async {
    // Update offline database first
    await _databaseService.updateGuestBook(guestBook);

    // Try to sync to online
    try {
      return await _apiService.updateGuestBook(guestBook);
    } catch (e) {
      // Return local data if online sync fails
      return guestBook;
    }
  }

  // Delete guest book (sync to both offline and online)
  Future<void> deleteGuestBook(int id) async {
    // Delete from offline database first
    await _databaseService.deleteGuestBook(id);

    // Try to sync to online
    try {
      await _apiService.deleteGuestBook(id);
    } catch (e) {
      // Continue if online delete fails
      // In a real app, you might want to queue this for retry
    }
  }

  // Sync offline data to online
  Future<void> syncToOnline() async {
    try {
      final offlineData = await getOfflineGuestBooks();
      
      for (final guestBook in offlineData) {
        try {
          if (guestBook.id != null) {
            // Try to update existing online record
            await _apiService.updateGuestBook(guestBook);
          } else {
            // Create new online record
            final onlineGuestBook = await _apiService.createGuestBook(guestBook);
            
            // Update local record with online ID
            await _databaseService.updateGuestBook(
              guestBook.copyWith(id: onlineGuestBook.id),
            );
          }
        } catch (e) {
          // Continue with next record if one fails
          continue;
        }
      }
    } catch (e) {
      // Sync failed
      rethrow;
    }
  }

  // Sync online data to offline
  Future<void> syncToOffline() async {
    try {
      final onlineData = await _apiService.getGuestBookList();
      
      for (final guestBook in onlineData) {
        final existingLocal = await _databaseService.getGuestBookById(guestBook.id!);
        
        if (existingLocal != null) {
          // Update existing local record
          await _databaseService.updateGuestBook(guestBook);
        } else {
          // Insert new local record
          await _databaseService.insertGuestBook(guestBook);
        }
      }
    } catch (e) {
      // Sync failed
      rethrow;
    }
  }

  // Full sync (both directions)
  Future<void> fullSync() async {
    try {
      await syncToOnline();
      await syncToOffline();
    } catch (e) {
      rethrow;
    }
  }
}