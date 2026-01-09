import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/comment_provider.dart';

class CommentPage extends StatefulWidget {
  final int postId; // Passed from the PostPage

  const CommentPage({super.key, required this.postId});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  void initState() {
    super.initState();
    // Fetch comments for THIS specific post ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentProvider>().fetchComments(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments for Post ${widget.postId}")),
      body: Consumer<CommentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          return ListView.builder(
            itemCount: provider.comments.length,
            itemBuilder: (context, index) {
              final comment = provider.comments[index];
              return ListTile(
                leading: const Icon(Icons.comment),
                title: Text(comment.email, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                subtitle: Text(comment.body),
              );
            },
          );
        },
      ),
    );
  }
}