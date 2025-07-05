import 'package:equatable/equatable.dart';

class GuestBiodata extends Equatable {
  final int? id;
  final int usersId;
  final String fullName;
  final String? address;
  final String? phoneNumber;
  final String? email;
  final DateTime? createdAt;

  const GuestBiodata({
    this.id,
    required this.usersId,
    required this.fullName,
    this.address,
    this.phoneNumber,
    this.email,
    this.createdAt,
  });

  factory GuestBiodata.fromJson(Map<String, dynamic> json) {
    return GuestBiodata(
      id: json['id'] as int?,
      usersId: json['users_id'] as int,
      fullName: json['full_name'] as String,
      address: json['address'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at'] as String)
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'users_id': usersId,
      'full_name': fullName,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'users_id': usersId,
      'full_name': fullName,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'created_at': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory GuestBiodata.fromMap(Map<String, dynamic> map) {
    return GuestBiodata(
      id: map['id'] as int?,
      usersId: map['users_id'] as int,
      fullName: map['full_name'] as String,
      address: map['address'] as String?,
      phoneNumber: map['phone_number'] as String?,
      email: map['email'] as String?,
      createdAt: map['created_at'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
        : null,
    );
  }

  GuestBiodata copyWith({
    int? id,
    int? usersId,
    String? fullName,
    String? address,
    String? phoneNumber,
    String? email,
    DateTime? createdAt,
  }) {
    return GuestBiodata(
      id: id ?? this.id,
      usersId: usersId ?? this.usersId,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id, 
    usersId, 
    fullName, 
    address, 
    phoneNumber, 
    email, 
    createdAt
  ];
}