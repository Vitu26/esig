// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostStore on _PostStore, Store {
  late final _$postsAtom = Atom(name: '_PostStore.posts', context: context);

  @override
  ObservableList<Post> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(ObservableList<Post> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_PostStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_PostStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$selectedPostAtom =
      Atom(name: '_PostStore.selectedPost', context: context);

  @override
  Post? get selectedPost {
    _$selectedPostAtom.reportRead();
    return super.selectedPost;
  }

  @override
  set selectedPost(Post? value) {
    _$selectedPostAtom.reportWrite(value, super.selectedPost, () {
      super.selectedPost = value;
    });
  }

  late final _$loadPostsAsyncAction =
      AsyncAction('_PostStore.loadPosts', context: context);

  @override
  Future<void> loadPosts() {
    return _$loadPostsAsyncAction.run(() => super.loadPosts());
  }

  late final _$createPostAsyncAction =
      AsyncAction('_PostStore.createPost', context: context);

  @override
  Future<void> createPost(
      {required String title,
      required String content,
      String? imageUrl,
      String? userId,
      String? username}) {
    return _$createPostAsyncAction.run(() => super.createPost(
        title: title,
        content: content,
        imageUrl: imageUrl,
        userId: userId,
        username: username));
  }

  late final _$updatePostAsyncAction =
      AsyncAction('_PostStore.updatePost', context: context);

  @override
  Future<void> updatePost(
      {required String objectId,
      required String title,
      required String content,
      String? imageUrl,
      String? userId,
      String? username}) {
    return _$updatePostAsyncAction.run(() => super.updatePost(
        objectId: objectId,
        title: title,
        content: content,
        imageUrl: imageUrl,
        userId: userId,
        username: username));
  }

  late final _$deletePostAsyncAction =
      AsyncAction('_PostStore.deletePost', context: context);

  @override
  Future<void> deletePost(String objectId) {
    return _$deletePostAsyncAction.run(() => super.deletePost(objectId));
  }

  late final _$_PostStoreActionController =
      ActionController(name: '_PostStore', context: context);

  @override
  void selectPost(Post post) {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.selectPost');
    try {
      return super.selectPost(post);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelectedPost() {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.clearSelectedPost');
    try {
      return super.clearSelectedPost();
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
posts: ${posts},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
selectedPost: ${selectedPost}
    ''';
  }
}
