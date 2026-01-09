import 'package:flutter/material.dart';
import '../../domain/entities/comment.dart';
import '../../domain/usecases/get_comments_usecase.dart';

class CommentProvider extends ChangeNotifier {
  final GetCommentsUseCase getCommentsUseCase;

  CommentProvider({required this.getCommentsUseCase});

  List<Comment> _comments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchComments(int postId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _comments = await getCommentsUseCase.execute(postId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}