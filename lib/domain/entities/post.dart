class Post {
  final String? objectId;
  final String title;
  final String content;
  final String? imageUrl;
  final String? userId; // ID do usuário que criou o post
  final String? username; // Nome do usuário (para exibição)
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    this.objectId,
    required this.title,
    required this.content,
    this.imageUrl,
    this.userId,
    this.username,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Post copyWith({
    String? objectId,
    String? title,
    String? content,
    String? imageUrl,
    String? userId,
    String? username,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      objectId: objectId ?? this.objectId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (objectId != null) 'objectId': objectId,
      'title': title,
      'content': content,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (userId != null) 'userId': userId,
      if (username != null) 'username': username,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

