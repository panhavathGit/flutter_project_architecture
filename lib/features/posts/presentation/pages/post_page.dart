import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../../../../features/comments/presentation/pages/comment_page.dart';
import '../pages/post_add_update_page.dart';
class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    super.initState();
    // Fetch posts when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clean Arch & Provider")),
      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          return ListView.builder(
            itemCount: provider.posts.length,
            itemBuilder: (context, index) {
              final post = provider.posts[index];
              // return ListTile(
              //   title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              //   subtitle: Text(post.body),
              // );
              
              // add push ListTile to view comment
              // return ListTile(
              //   title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              //   subtitle: Text(post.body),
              //   trailing: const Icon(Icons.arrow_forward_ios), // Add an arrow
              //   onTap: () {
              //     // Navigate to CommentPage and pass the post ID
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => CommentPage(postId: post.id),
              //       ),
              //     );
              //   },
              // );

              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // EDIT BUTTON
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostAddUpdatePage(post: post),
                          ),
                        );
                      },
                    ),
                    // DELETE BUTTON
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<PostProvider>().deletePost(post.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // Add FloatingActionButton to Scaffold
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostAddUpdatePage()),
          );
        },
      ),
    );
  }
}