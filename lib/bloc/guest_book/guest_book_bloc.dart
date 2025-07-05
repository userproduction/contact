import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/guest_book_repository.dart';
import 'guest_book_event.dart';
import 'guest_book_state.dart';

class GuestBookBloc extends Bloc<GuestBookEvent, GuestBookState> {
  final GuestBookRepository _guestBookRepository;

  GuestBookBloc({required GuestBookRepository guestBookRepository})
      : _guestBookRepository = guestBookRepository,
        super(GuestBookInitial()) {
    on<GuestBookLoadOfflineRequested>(_onGuestBookLoadOfflineRequested);
    on<GuestBookLoadOnlineRequested>(_onGuestBookLoadOnlineRequested);
    on<GuestBookLoadByIdRequested>(_onGuestBookLoadByIdRequested);
    on<GuestBookCreateRequested>(_onGuestBookCreateRequested);
    on<GuestBookUpdateRequested>(_onGuestBookUpdateRequested);
    on<GuestBookDeleteRequested>(_onGuestBookDeleteRequested);
    on<GuestBookSyncToOnlineRequested>(_onGuestBookSyncToOnlineRequested);
    on<GuestBookSyncToOfflineRequested>(_onGuestBookSyncToOfflineRequested);
    on<GuestBookFullSyncRequested>(_onGuestBookFullSyncRequested);
  }

  Future<void> _onGuestBookLoadOfflineRequested(
    GuestBookLoadOfflineRequested event,
    Emitter<GuestBookState> emit,
  ) async {
    try {
      emit(GuestBookLoading());
      
      final guestBooks = await _guestBookRepository.getOfflineGuestBooks();
      
      emit(GuestBookListLoaded(guestBooks: guestBooks, isOffline: true));
    } catch (e) {
      emit(GuestBookError(message: e.toString()));
    }
  }

  Future<void> _onGuestBookLoadOnlineRequested(
    GuestBookLoadOnlineRequested event,
    Emitter<GuestBookState> emit,
  ) async {
    try {
      emit(GuestBookLoading());
      
      final guestBooks = await _guestBookRepository.getOnlineGuestBooks();
      
      emit(GuestBookListLoaded(guestBooks: guestBooks, isOffline: false));
    } catch (e) {
      emit(GuestBookError(message: e.toString()));
    }
  }

  Future<void> _onGuestBookLoadByIdRequested(
    GuestBookLoadByIdRequested event,
    Emitter<GuestBookState> emit,
  ) async {
    try {
      emit(GuestBookLoading());
      
      final guestBook = await _guestBookRepository.getGuestBook(
        event.id,
        fromOnline: event.fromOnline,
      );
      
      if (guestBook != null) {
        emit(GuestBookDetailLoaded(guestBook: guestBook));
      } else {
        emit(const GuestBookError(message: 'Guest book not found'));
      }
    } catch (e) {
      emit(GuestBookError(message: e.toString()));
    }
  }

  Future<void> _onGuestBookCreateRequested(
    GuestBookCreateRequested event,
    Emitter<GuestBookState> emit,
  ) async {
    try {
      emit(GuestBookLoading());
      
      final createdGuestBook = await _guestBookRepository.createGuestBook(event.guestBook);
      
      emit(GuestBookOperationSuccess(
        message: 'Guest book entry created successfully',
        guestBook: createdGuestBook,
      ));
    } catch (e) {
      emit(GuestBookError(message: e.toString()));
    }
  }

  Future<void> _onGuestBookUpdateRequested(
    GuestBookUpdateRequested event,
    Emitter<GuestBookState> emit,
  ) async {
    try {
      emit(GuestBookLoading());
      
      final updatedGuestBook = await _guestBookRepository.updateGuestBook(event.guestBook);
      
      emit(GuestBookOperationSuccess(
        message: 'Guest book entry updated successfully',
        guestBook: updatedGuestBook,
      ));
    } catch (e) {
      emit(GuestBookError(message: e.toString()));
    }
  }

  Future<void> _onGuestBookDeleteRequested(
    GuestBookDeleteRequested event,
    Emitter<GuestBookState> emit,
  ) async {
    try {
      emit(GuestBookLoading());
      
      await _guestBookRepository.deleteGuestBook(event.id);
      
      emit(const GuestBookOperationSuccess(
        message: 'Guest book entry deleted successfully',
      ));
    } catch (e) {
      emit(GuestBookError(message: e.toString()));
    }
  }

  Future<void> _onGuestBookSyncToOnlineRequested(
    GuestBookSyncToOnlineRequested event,
    Emitter<GuestBookState> emit,
  ) async {
    try {
      emit(GuestBookLoading());
      
      await _guestBookRepository.syncToOnline();
      
      emit(const GuestBookSyncSuccess(message: 'Guest books synced to online successfully'));
    } catch (e) {
      emit(GuestBookError(message: 'Sync to online failed: ${e.toString()}'));
    }
  }

  Future<void> _onGuestBookSyncToOfflineRequested(
    GuestBookSyncToOfflineRequested event,
    Emitter<GuestBookState> emit,
  ) async {
    try {
      emit(GuestBookLoading());
      
      await _guestBookRepository.syncToOffline();
      
      emit(const GuestBookSyncSuccess(message: 'Guest books synced to offline successfully'));
    } catch (e) {
      emit(GuestBookError(message: 'Sync to offline failed: ${e.toString()}'));
    }
  }

  Future<void> _onGuestBookFullSyncRequested(
    GuestBookFullSyncRequested event,
    Emitter<GuestBookState> emit,
  ) async {
    try {
      emit(GuestBookLoading());
      
      await _guestBookRepository.fullSync();
      
      emit(const GuestBookSyncSuccess(message: 'Full sync completed successfully'));
    } catch (e) {
      emit(GuestBookError(message: 'Full sync failed: ${e.toString()}'));
    }
  }
}