class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime lastSignInAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.isEmailVerified,
    required this.createdAt,
    required this.lastSignInAt,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, photoUrl: $photoUrl, isEmailVerified: $isEmailVerified, createdAt: $createdAt, lastSignInAt: $lastSignInAt)';
  }
}
