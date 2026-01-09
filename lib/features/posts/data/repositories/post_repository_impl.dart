import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Post>> getPosts() async {
    return await remoteDataSource.fetchPosts();
  }

  @override
  Future<Post> addPost(Post post) async {
    return await remoteDataSource.addPost(post);
  }

  @override
  Future<Post> updatePost(Post post) async {
    return await remoteDataSource.updatePost(post);
  }

  @override
  Future<void> deletePost(int id) async {
    return await remoteDataSource.deletePost(id);
  }
}