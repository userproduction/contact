import '../models/guest_biodata.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class GuestRepository {
  final ApiService _apiService;
  final DatabaseService _databaseService;

  GuestRepository({
    required ApiService apiService,
    required DatabaseService databaseService,
  })  : _apiService = apiService,
        _databaseService = databaseService;

  // Get all guest biodata (offline)
  Future<List<GuestBiodata>> getOfflineGuestBiodata() async {
    return await _databaseService.getAllGuestBiodata();
  }

  // Get all guest biodata (online)
  Future<List<GuestBiodata>> getOnlineGuestBiodata() async {
    try {
      return await _apiService.getGuestBiodataList();
    } catch (e) {
      // Fallback to offline data if online fails
      return await getOfflineGuestBiodata();
    }
  }

  // Get specific guest biodata by ID
  Future<GuestBiodata?> getGuestBiodata(int id, {bool fromOnline = false}) async {
    if (fromOnline) {
      try {
        return await _apiService.getGuestBiodata(id);
      } catch (e) {
        // Fallback to offline data
        return await _databaseService.getGuestBiodataById(id);
      }
    } else {
      return await _databaseService.getGuestBiodataById(id);
    }
  }

  // Get guest biodata by user ID
  Future<GuestBiodata?> getGuestBiodataByUserId(int userId) async {
    return await _databaseService.getGuestBiodataByUserId(userId);
  }

  // Create new guest biodata (sync to both offline and online)
  Future<GuestBiodata> createGuestBiodata(GuestBiodata guestBiodata) async {
    // Save to offline database first
    final guestBiodataWithId = guestBiodata.copyWith(
      createdAt: DateTime.now(),
    );
    
    final localId = await _databaseService.insertGuestBiodata(guestBiodataWithId);
    final localGuestBiodata = guestBiodataWithId.copyWith(id: localId);

    // Try to sync to online
    try {
      final onlineGuestBiodata = await _apiService.createGuestBiodata(localGuestBiodata);
      
      // Update local data with online ID if different
      if (onlineGuestBiodata.id != localId) {
        await _databaseService.updateGuestBiodata(
          localGuestBiodata.copyWith(id: onlineGuestBiodata.id),
        );
      }
      
      return onlineGuestBiodata;
    } catch (e) {
      // Return local data if online sync fails
      return localGuestBiodata;
    }
  }

  // Update guest biodata (sync to both offline and online)
  Future<GuestBiodata> updateGuestBiodata(GuestBiodata guestBiodata) async {
    // Update offline database first
    await _databaseService.updateGuestBiodata(guestBiodata);

    // Try to sync to online
    try {
      return await _apiService.updateGuestBiodata(guestBiodata);
    } catch (e) {
      // Return local data if online sync fails
      return guestBiodata;
    }
  }

  // Sync offline data to online
  Future<void> syncToOnline() async {
    try {
      final offlineData = await getOfflineGuestBiodata();
      
      for (final guestBiodata in offlineData) {
        try {
          if (guestBiodata.id != null) {
            // Try to update existing online record
            await _apiService.updateGuestBiodata(guestBiodata);
          } else {
            // Create new online record
            final onlineGuestBiodata = await _apiService.createGuestBiodata(guestBiodata);
            
            // Update local record with online ID
            await _databaseService.updateGuestBiodata(
              guestBiodata.copyWith(id: onlineGuestBiodata.id),
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
      final onlineData = await _apiService.getGuestBiodataList();
      
      for (final guestBiodata in onlineData) {
        final existingLocal = await _databaseService.getGuestBiodataById(guestBiodata.id!);
        
        if (existingLocal != null) {
          // Update existing local record
          await _databaseService.updateGuestBiodata(guestBiodata);
        } else {
          // Insert new local record
          await _databaseService.insertGuestBiodata(guestBiodata);
        }
      }
    } catch (e) {
      // Sync failed
      rethrow;
    }
  }
}