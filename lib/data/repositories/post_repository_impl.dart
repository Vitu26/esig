import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';
import '../datasources/post_local_datasource.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource remoteDatasource;
  final PostLocalDatasource localDatasource;

  PostRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<Post>> getPosts() async {
    return await localDatasource.getPosts();
  }

  @override
  Future<Post> createPost(Post post) async {
    final postModel = PostModel(
      objectId: DateTime.now().millisecondsSinceEpoch.toString(),
      title: post.title,
      content: post.content,
      imageUrl: post.imageUrl,
      userId: post.userId,
      username: post.username,
    );
    
    final posts = await localDatasource.getPosts();
    posts.add(postModel);
    await localDatasource.savePosts(posts);
    return postModel;
  }

  @override
  Future<Post> updatePost(Post post) async {
    if (post.objectId == null) {
      throw Exception('Post objectId is required for update');
    }

    final postModel = PostModel(
      objectId: post.objectId,
      title: post.title,
      content: post.content,
      imageUrl: post.imageUrl,
      userId: post.userId,
      username: post.username,
      updatedAt: DateTime.now(),
    );

    final posts = await localDatasource.getPosts();
    final index = posts.indexWhere((p) => p.objectId == post.objectId);
    if (index != -1) {
      posts[index] = postModel;
      await localDatasource.savePosts(posts);
      return postModel;
    }
    throw Exception('Post not found');
  }

  @override
  Future<void> deletePost(String objectId) async {
    final posts = await localDatasource.getPosts();
    posts.removeWhere((p) => p.objectId == objectId);
    await localDatasource.savePosts(posts);
  }
}

