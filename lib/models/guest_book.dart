import 'package:equatable/equatable.dart';
import 'guest_biodata.dart';

class GuestBook extends Equatable {
  final int? id;
  final int guessId;
  final String message;
  final int? createdBy;
  final DateTime? createdAt;
  final GuestBiodata? guestBiodata; // For joins

  const GuestBook({
    this.id,
    required this.guessId,
    required this.message,
    this.createdBy,
    this.createdAt,
    this.guestBiodata,
  });

  factory GuestBook.fromJson(Map<String, dynamic> json) {
    return GuestBook(
      id: json['id'] as int?,
      guessId: json['guess_id'] as int,
      message: json['message'] as String,
      createdBy: json['created_by'] as int?,
      createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at'] as String)
        : null,
      guestBiodata: json['guest_biodata'] != null 
        ? GuestBiodata.fromJson(json['guest_biodata'] as Map<String, dynamic>)
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guess_id': guessId,
      'message': message,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'guest_biodata': guestBiodata?.toJson(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guess_id': guessId,
      'message': message,
      'created_by': createdBy,
      'created_at': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory GuestBook.fromMap(Map<String, dynamic> map) {
    return GuestBook(
      id: map['id'] as int?,
      guessId: map['guess_id'] as int,
      message: map['message'] as String,
      createdBy: map['created_by'] as int?,
      createdAt: map['created_at'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
        : null,
    );
  }

  GuestBook copyWith({
    int? id,
    int? guessId,
    String? message,
    int? createdBy,
    DateTime? createdAt,
    GuestBiodata? guestBiodata,
  }) {
    return GuestBook(
      id: id ?? this.id,
      guessId: guessId ?? this.guessId,
      message: message ?? this.message,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      guestBiodata: guestBiodata ?? this.guestBiodata,
    );
  }

  @override
  List<Object?> get props => [
    id, 
    guessId, 
    message, 
    createdBy, 
    createdAt,
    guestBiodata,
  ];
}