import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

abstract class PostLocalDatasource {
  Future<List<PostModel>> getPosts();
  Future<void> savePosts(List<PostModel> posts);
  Future<void> clearPosts();
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  static const String _postsKey = 'posts_key';

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = prefs.getString(_postsKey);
      
      if (postsJson == null) {
        return [];
      }
      
      final List<dynamic> postsList = json.decode(postsJson);
      return postsList
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> savePosts(List<PostModel> posts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = json.encode(
        posts.map((post) => post.toJson()).toList(),
      );
      await prefs.setString(_postsKey, postsJson);
    } catch (e) {
      throw Exception('Error saving posts locally: $e');
    }
  }

  @override
  Future<void> clearPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_postsKey);
    } catch (e) {
      throw Exception('Error clearing posts: $e');
    }
  }
}

