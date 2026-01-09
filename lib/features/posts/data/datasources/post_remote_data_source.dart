import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../../domain/entities/post.dart';

class PostRemoteDataSource {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<PostModel>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<PostModel> addPost(Post post) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({
        'title': post.title,
        'body': post.body,
        'userId': 1,
      }),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 201) {
      // Parse the response body to get the created post with its ID
      final jsonResponse = json.decode(response.body);
      return PostModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to add post: ${response.statusCode} - ${response.body}');
    }
  }

  Future<PostModel> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${post.id}'),
      body: jsonEncode({
        'id': post.id,
        'title': post.title,
        'body': post.body,
        'userId': 1,
      }),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PostModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to update post: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}