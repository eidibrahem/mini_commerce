class ProfileEntity {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final DateTime? dateOfBirth;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileEntity({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.dateOfBirth,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  ProfileEntity copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProfileEntity(id: $id, userId: $userId, fullName: $fullName)';
  }
}
