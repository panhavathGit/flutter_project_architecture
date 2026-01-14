import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/add_post_usecase.dart';
import '../../domain/usecases/update_post_usecase.dart';
import '../../domain/usecases/delete_post_usecase.dart';

class PostProvider extends ChangeNotifier {
  final GetPostsUseCase getPostsUseCase;
  final AddPostUseCase addPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  final DeletePostUseCase deletePostUseCase;

  PostProvider({
    required this.getPostsUseCase,
    required this.addPostUseCase,
    required this.updatePostUseCase,
    required this.deletePostUseCase,
  });

  // State variables
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Event: Fetch Data
  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _posts = await getPostsUseCase.execute();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- CRUD OPERATIONS ---
  Future<void> addPost(String title, String content, {String author = 'Anonymous'}) async {
    try {
      _errorMessage = null;
      
      // Create a temporary post object (ID 0 for new posts)
      final newPost = Post(
        id: 0, 
        title: title, 
        content: content,
        author: author,
      );

      // Call API
      final result = await addPostUseCase.execute(newPost);

      // Add to top of list
      _posts.insert(0, result);
      notifyListeners();
      
    } catch (e) {
      _errorMessage = "Failed to create post: ${e.toString()}";
      notifyListeners();
      rethrow;
    }
  }

  /// Update an existing post
  Future<void> updatePost(
    int id, 
    String title, 
    String content, 
    {String? author}
  ) async {
    try {
      _errorMessage = null;
      
      // Find the current post to preserve author if not provided
      final currentPost = _posts.firstWhere((p) => p.id == id);
      
      final updatedPost = Post(
        id: id, 
        title: title, 
        content: content,
        author: author ?? currentPost.author,
      );
      
      // Call API and get the updated post
      final result = await updatePostUseCase.execute(updatedPost);

      // Update local list
      final index = _posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _posts[index] = result;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Failed to update post: ${e.toString()}";
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a post by ID
  Future<void> deletePost(int id) async {
    try {
      _errorMessage = null;
      
      // Call API
      await deletePostUseCase.execute(id);

      // Remove from local list
      _posts.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to delete post: ${e.toString()}";
      notifyListeners();
      rethrow;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}