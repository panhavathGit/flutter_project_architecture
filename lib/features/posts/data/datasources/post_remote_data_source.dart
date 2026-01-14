import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../../domain/entities/post.dart';
import '../../../../core/constants/api_constants.dart';

class PostRemoteDataSource {
  final String baseUrl = ApiConstants.posts;

  Future<List<PostModel>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }

  Future<PostModel> addPost(Post post) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({
        'title': post.title,
        'content': post.content,
        'author': post.author,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return PostModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add post: ${response.statusCode}');
    }
  }

  Future<PostModel> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${post.id}'),
      body: jsonEncode({
        'title': post.title,
        'content': post.content,
        'author': post.author,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return PostModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update post: ${response.statusCode}');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    // Backend returns 204 No Content on success
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}
