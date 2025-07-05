import 'package:equatable/equatable.dart';
import '../../models/guest_book.dart';

abstract class GuestBookEvent extends Equatable {
  const GuestBookEvent();

  @override
  List<Object?> get props => [];
}

class GuestBookLoadOfflineRequested extends GuestBookEvent {}

class GuestBookLoadOnlineRequested extends GuestBookEvent {}

class GuestBookLoadByIdRequested extends GuestBookEvent {
  final int id;
  final bool fromOnline;

  const GuestBookLoadByIdRequested({
    required this.id,
    this.fromOnline = false,
  });

  @override
  List<Object?> get props => [id, fromOnline];
}

class GuestBookCreateRequested extends GuestBookEvent {
  final GuestBook guestBook;

  const GuestBookCreateRequested({required this.guestBook});

  @override
  List<Object?> get props => [guestBook];
}

class GuestBookUpdateRequested extends GuestBookEvent {
  final GuestBook guestBook;

  const GuestBookUpdateRequested({required this.guestBook});

  @override
  List<Object?> get props => [guestBook];
}

class GuestBookDeleteRequested extends GuestBookEvent {
  final int id;

  const GuestBookDeleteRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

class GuestBookSyncToOnlineRequested extends GuestBookEvent {}

class GuestBookSyncToOfflineRequested extends GuestBookEvent {}

class GuestBookFullSyncRequested extends GuestBookEvent {}