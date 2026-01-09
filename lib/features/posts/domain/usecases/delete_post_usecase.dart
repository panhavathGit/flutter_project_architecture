// import '../entities/post.dart';
import '../repositories/post_repository.dart';

class DeletePostUseCase {
  final PostRepository repository;
  DeletePostUseCase(this.repository);

  Future<void> execute(int id) {
    return repository.deletePost(id);
  }
}