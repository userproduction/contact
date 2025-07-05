import 'package:equatable/equatable.dart';
import '../../models/guest_book.dart';

abstract class GuestBookState extends Equatable {
  const GuestBookState();

  @override
  List<Object?> get props => [];
}

class GuestBookInitial extends GuestBookState {}

class GuestBookLoading extends GuestBookState {}

class GuestBookListLoaded extends GuestBookState {
  final List<GuestBook> guestBooks;
  final bool isOffline;

  const GuestBookListLoaded({
    required this.guestBooks,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [guestBooks, isOffline];
}

class GuestBookDetailLoaded extends GuestBookState {
  final GuestBook guestBook;

  const GuestBookDetailLoaded({required this.guestBook});

  @override
  List<Object?> get props => [guestBook];
}

class GuestBookOperationSuccess extends GuestBookState {
  final String message;
  final GuestBook? guestBook;

  const GuestBookOperationSuccess({
    required this.message,
    this.guestBook,
  });

  @override
  List<Object?> get props => [message, guestBook];
}

class GuestBookSyncSuccess extends GuestBookState {
  final String message;

  const GuestBookSyncSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class GuestBookError extends GuestBookState {
  final String message;

  const GuestBookError({required this.message});

  @override
  List<Object?> get props => [message];
}