import 'package:equatable/equatable.dart';
import '../../models/guest_biodata.dart';

abstract class GuestState extends Equatable {
  const GuestState();

  @override
  List<Object?> get props => [];
}

class GuestInitial extends GuestState {}

class GuestLoading extends GuestState {}

class GuestListLoaded extends GuestState {
  final List<GuestBiodata> guests;
  final bool isOffline;

  const GuestListLoaded({
    required this.guests,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [guests, isOffline];
}

class GuestDetailLoaded extends GuestState {
  final GuestBiodata guest;

  const GuestDetailLoaded({required this.guest});

  @override
  List<Object?> get props => [guest];
}

class GuestOperationSuccess extends GuestState {
  final String message;
  final GuestBiodata? guest;

  const GuestOperationSuccess({
    required this.message,
    this.guest,
  });

  @override
  List<Object?> get props => [message, guest];
}

class GuestSyncSuccess extends GuestState {
  final String message;

  const GuestSyncSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class GuestError extends GuestState {
  final String message;

  const GuestError({required this.message});

  @override
  List<Object?> get props => [message];
}