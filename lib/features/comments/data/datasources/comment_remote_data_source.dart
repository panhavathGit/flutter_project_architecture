import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment_model.dart';

class CommentRemoteDataSource {
  Future<List<CommentModel>> fetchComments(int postId) async {
    // JSONPlaceholder allows filtering by query parameter
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=$postId')
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }
}