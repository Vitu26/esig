import '../../domain/entities/post.dart';

class PostModel extends Post {
  PostModel({
    super.objectId,
    required super.title,
    required super.content,
    super.imageUrl,
    super.userId,
    super.username,
    super.createdAt,
    super.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      objectId: json['objectId'] as String?,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  factory PostModel.fromParseJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now();
    final updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : DateTime.now();

    return PostModel(
      objectId: json['objectId'] as String?,
      title: (json['Title'] ?? json['title']) as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toParseJson() {
    final json = <String, dynamic>{
      'title': title,
      'content': content,
    };
    
    if (imageUrl != null) {
      json['imageUrl'] = imageUrl;
    }
    
    if (userId != null) {
      json['userId'] = userId;
    }
    
    if (username != null) {
      json['username'] = username;
    }
    
    return json;
  }

  @override
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

