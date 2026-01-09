import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/add_post_usecase.dart';
import '../../domain/usecases/update_post_usecase.dart';
import '../../domain/usecases/delete_post_usecase.dart';

class PostProvider extends ChangeNotifier {
  final GetPostsUseCase getPostsUseCase;

  final AddPostUseCase addPostUseCase;       // NEW
  final UpdatePostUseCase updatePostUseCase; // NEW
  final DeletePostUseCase deletePostUseCase; // NEW

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
    notifyListeners(); // Update UI to show spinner

    try {
      _posts = await getPostsUseCase.execute();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Update UI to show data or error
    }
  }

   // --- CRUD OPERATIONS ---

  Future<void> addPost(String title, String body) async {
    try {
      _errorMessage = null;
      
      // 1. Create a temporary object (ID 0 represents a new item)
      final newPost = Post(id: 0, title: title, body: body);

      // 2. Call API
      final result = await addPostUseCase.execute(newPost);

      // 3. API Success? Update LOCAL list manually so UI updates
      _posts.insert(0, result); // Add to top of list
      notifyListeners();
      
    } catch (e) {
      _errorMessage = "Failed to create post: ${e.toString()}";
      notifyListeners();
      rethrow; // Re-throw to let UI handle it
    }
  }

  Future<void> updatePost(int id, String title, String body) async {
    try {
      _errorMessage = null;
      final updatedPost = Post(id: id, title: title, body: body);
      
      // 1. Call API and get the updated post
      final result = await updatePostUseCase.execute(updatedPost);

      // 2. API Success? Update LOCAL list with the returned PostModel
      final index = _posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _posts[index] = result;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Failed to update post: ${e.toString()}";
      notifyListeners();
      rethrow; // Re-throw to let UI handle it
    }
  }

  Future<void> deletePost(int id) async {
    try {
      // 1. Call API
      await deletePostUseCase.execute(id);

      // 2. API Success? Remove from LOCAL list
      _posts.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to delete";
      notifyListeners();
    }
  }
}