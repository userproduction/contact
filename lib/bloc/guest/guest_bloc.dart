import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/guest_repository.dart';
import 'guest_event.dart';
import 'guest_state.dart';

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  final GuestRepository _guestRepository;

  GuestBloc({required GuestRepository guestRepository})
      : _guestRepository = guestRepository,
        super(GuestInitial()) {
    on<GuestLoadOfflineRequested>(_onGuestLoadOfflineRequested);
    on<GuestLoadOnlineRequested>(_onGuestLoadOnlineRequested);
    on<GuestLoadByIdRequested>(_onGuestLoadByIdRequested);
    on<GuestLoadByUserIdRequested>(_onGuestLoadByUserIdRequested);
    on<GuestCreateRequested>(_onGuestCreateRequested);
    on<GuestUpdateRequested>(_onGuestUpdateRequested);
    on<GuestSyncToOnlineRequested>(_onGuestSyncToOnlineRequested);
    on<GuestSyncToOfflineRequested>(_onGuestSyncToOfflineRequested);
  }

  Future<void> _onGuestLoadOfflineRequested(
    GuestLoadOfflineRequested event,
    Emitter<GuestState> emit,
  ) async {
    try {
      emit(GuestLoading());
      
      final guests = await _guestRepository.getOfflineGuestBiodata();
      
      emit(GuestListLoaded(guests: guests, isOffline: true));
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onGuestLoadOnlineRequested(
    GuestLoadOnlineRequested event,
    Emitter<GuestState> emit,
  ) async {
    try {
      emit(GuestLoading());
      
      final guests = await _guestRepository.getOnlineGuestBiodata();
      
      emit(GuestListLoaded(guests: guests, isOffline: false));
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onGuestLoadByIdRequested(
    GuestLoadByIdRequested event,
    Emitter<GuestState> emit,
  ) async {
    try {
      emit(GuestLoading());
      
      final guest = await _guestRepository.getGuestBiodata(
        event.id,
        fromOnline: event.fromOnline,
      );
      
      if (guest != null) {
        emit(GuestDetailLoaded(guest: guest));
      } else {
        emit(const GuestError(message: 'Guest not found'));
      }
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onGuestLoadByUserIdRequested(
    GuestLoadByUserIdRequested event,
    Emitter<GuestState> emit,
  ) async {
    try {
      emit(GuestLoading());
      
      final guest = await _guestRepository.getGuestBiodataByUserId(event.userId);
      
      if (guest != null) {
        emit(GuestDetailLoaded(guest: guest));
      } else {
        emit(const GuestError(message: 'Guest biodata not found for this user'));
      }
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onGuestCreateRequested(
    GuestCreateRequested event,
    Emitter<GuestState> emit,
  ) async {
    try {
      emit(GuestLoading());
      
      final createdGuest = await _guestRepository.createGuestBiodata(event.guestBiodata);
      
      emit(GuestOperationSuccess(
        message: 'Guest biodata created successfully',
        guest: createdGuest,
      ));
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onGuestUpdateRequested(
    GuestUpdateRequested event,
    Emitter<GuestState> emit,
  ) async {
    try {
      emit(GuestLoading());
      
      final updatedGuest = await _guestRepository.updateGuestBiodata(event.guestBiodata);
      
      emit(GuestOperationSuccess(
        message: 'Guest biodata updated successfully',
        guest: updatedGuest,
      ));
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onGuestSyncToOnlineRequested(
    GuestSyncToOnlineRequested event,
    Emitter<GuestState> emit,
  ) async {
    try {
      emit(GuestLoading());
      
      await _guestRepository.syncToOnline();
      
      emit(const GuestSyncSuccess(message: 'Data synced to online successfully'));
    } catch (e) {
      emit(GuestError(message: 'Sync to online failed: ${e.toString()}'));
    }
  }

  Future<void> _onGuestSyncToOfflineRequested(
    GuestSyncToOfflineRequested event,
    Emitter<GuestState> emit,
  ) async {
    try {
      emit(GuestLoading());
      
      await _guestRepository.syncToOffline();
      
      emit(const GuestSyncSuccess(message: 'Data synced to offline successfully'));
    } catch (e) {
      emit(GuestError(message: 'Sync to offline failed: ${e.toString()}'));
    }
  }
}