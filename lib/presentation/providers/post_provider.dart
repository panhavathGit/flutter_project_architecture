import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_posts_usecase.dart';

class PostProvider extends ChangeNotifier {
  final GetPostsUseCase getPostsUseCase;

  PostProvider({required this.getPostsUseCase});

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
}