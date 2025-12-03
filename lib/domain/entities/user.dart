class User {
  final String? objectId;
  final String username;
  final String? email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.objectId,
    required this.username,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    String? objectId,
    String? username,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      objectId: objectId ?? this.objectId,
      username: username ?? this.username,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (objectId != null) 'objectId': objectId,
      'username': username,
      if (email != null) 'email': email,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

