import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository repository;

  GetCommentsUseCase(this.repository);

  // We pass the postId here
  Future<List<Comment>> execute(int postId) {
    return repository.getComments(postId);
  }
}