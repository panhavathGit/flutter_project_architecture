import '../entities/post.dart';
import '../repositories/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository repository;
  UpdatePostUseCase(this.repository);

  Future<Post> execute(Post post) {
    return repository.updatePost(post);
  }
}