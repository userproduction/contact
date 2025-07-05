import 'package:equatable/equatable.dart';
import '../../models/guest_biodata.dart';

abstract class GuestEvent extends Equatable {
  const GuestEvent();

  @override
  List<Object?> get props => [];
}

class GuestLoadOfflineRequested extends GuestEvent {}

class GuestLoadOnlineRequested extends GuestEvent {}

class GuestLoadByIdRequested extends GuestEvent {
  final int id;
  final bool fromOnline;

  const GuestLoadByIdRequested({
    required this.id,
    this.fromOnline = false,
  });

  @override
  List<Object?> get props => [id, fromOnline];
}

class GuestLoadByUserIdRequested extends GuestEvent {
  final int userId;

  const GuestLoadByUserIdRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GuestCreateRequested extends GuestEvent {
  final GuestBiodata guestBiodata;

  const GuestCreateRequested({required this.guestBiodata});

  @override
  List<Object?> get props => [guestBiodata];
}

class GuestUpdateRequested extends GuestEvent {
  final GuestBiodata guestBiodata;

  const GuestUpdateRequested({required this.guestBiodata});

  @override
  List<Object?> get props => [guestBiodata];
}

class GuestSyncToOnlineRequested extends GuestEvent {}

class GuestSyncToOfflineRequested extends GuestEvent {}