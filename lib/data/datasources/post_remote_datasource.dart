import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/post_model.dart';

abstract class PostRemoteDatasource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> createPost(PostModel post);
  Future<PostModel> updatePost(PostModel post);
  Future<void> deletePost(String objectId);
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  final Dio dio;

  PostRemoteDatasourceImpl(this.dio);

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await dio.get(
        ApiConstants.postsEndpoint,
        options: Options(
          headers: {
            'X-Parse-Application-Id': ApiConstants.applicationId,
            'X-Parse-REST-API-Key': ApiConstants.clientKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results
            .map((json) => PostModel.fromParseJson(json as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to load posts');
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Future<PostModel> createPost(PostModel post) async {
    try {
      final response = await dio.post(
        ApiConstants.postsEndpoint,
        data: post.toParseJson(),
        options: Options(
          headers: {
            'X-Parse-Application-Id': ApiConstants.applicationId,
            'X-Parse-REST-API-Key': ApiConstants.clientKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        return PostModel.fromParseJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to create post');
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<PostModel> updatePost(PostModel post) async {
    try {
      final response = await dio.put(
        '${ApiConstants.postsEndpoint}/${post.objectId}',
        data: post.toParseJson(),
        options: Options(
          headers: {
            'X-Parse-Application-Id': ApiConstants.applicationId,
            'X-Parse-REST-API-Key': ApiConstants.clientKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return PostModel.fromParseJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to update post');
    } catch (e) {
      throw Exception('Error updating post: $e');
    }
  }

  @override
  Future<void> deletePost(String objectId) async {
    try {
      final response = await dio.delete(
        '${ApiConstants.postsEndpoint}/$objectId',
        options: Options(
          headers: {
            'X-Parse-Application-Id': ApiConstants.applicationId,
            'X-Parse-REST-API-Key': ApiConstants.clientKey,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }
}

