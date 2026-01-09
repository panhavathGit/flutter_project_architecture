import '../entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();

  // New CRUD methods
  Future<Post> addPost(Post post);
  Future<Post> updatePost(Post post);
  Future<void> deletePost(int id);
  
}