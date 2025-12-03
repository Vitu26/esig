import 'package:mobx/mobx.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';

part 'post_store.g.dart';

class PostStore = _PostStore with _$PostStore;

abstract class _PostStore with Store {
  final PostRepository postRepository;

  _PostStore(this.postRepository);

  @observable
  ObservableList<Post> posts = ObservableList<Post>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  Post? selectedPost;

  @action
  Future<void> loadPosts() async {
    isLoading = true;
    errorMessage = null;

    try {
      final loadedPosts = await postRepository.getPosts();
      posts.clear();
      posts.addAll(loadedPosts);
    } catch (e) {
      errorMessage = 'Erro ao carregar posts: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> createPost({
    required String title,
    required String content,
    String? imageUrl,
    String? userId,
    String? username,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final newPost = Post(
        title: title,
        content: content,
        imageUrl: imageUrl,
        userId: userId,
        username: username,
      );
      final createdPost = await postRepository.createPost(newPost);
      posts.insert(0, createdPost);
    } catch (e) {
      errorMessage = 'Erro ao criar post: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updatePost({
    required String objectId,
    required String title,
    required String content,
    String? imageUrl,
    String? userId,
    String? username,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final postToUpdate = Post(
        objectId: objectId,
        title: title,
        content: content,
        imageUrl: imageUrl,
        userId: userId,
        username: username,
      );
      final updatedPost = await postRepository.updatePost(postToUpdate);
      
      final index = posts.indexWhere((p) => p.objectId == objectId);
      if (index != -1) {
        posts[index] = updatedPost;
      }
      
      if (selectedPost?.objectId == objectId) {
        selectedPost = updatedPost;
      }
    } catch (e) {
      errorMessage = 'Erro ao atualizar post: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> deletePost(String objectId) async {
    isLoading = true;
    errorMessage = null;

    try {
      await postRepository.deletePost(objectId);
      posts.removeWhere((p) => p.objectId == objectId);
      
      if (selectedPost?.objectId == objectId) {
        selectedPost = null;
      }
    } catch (e) {
      errorMessage = 'Erro ao deletar post: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  void selectPost(Post post) {
    selectedPost = post;
  }

  @action
  void clearSelectedPost() {
    selectedPost = null;
  }
}

