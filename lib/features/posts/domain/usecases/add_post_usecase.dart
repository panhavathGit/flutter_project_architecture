import '../entities/post.dart';
import '../repositories/post_repository.dart';

class AddPostUseCase {
  final PostRepository repository;
  AddPostUseCase(this.repository);

  Future<Post> execute(Post post) {
    return repository.addPost(post);
  }
}