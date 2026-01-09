import '../entities/comment.dart';

abstract class CommentRepository {
  // Notice we need an Input now: postId
  Future<List<Comment>> getComments(int postId);
  
}