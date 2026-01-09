import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../../domain/entities/post.dart';

class PostAddUpdatePage extends StatefulWidget {
  final Post? post; // If null, we are in "Add Mode". If not null, "Edit Mode"

  const PostAddUpdatePage({super.key, this.post});

  @override
  State<PostAddUpdatePage> createState() => _PostAddUpdatePageState();
}

class _PostAddUpdatePageState extends State<PostAddUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.post != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Post" : "New Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) => value!.isEmpty ? "Enter a title" : null,
              ),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: "Body"),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? "Enter a body" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final provider = context.read<PostProvider>();
                    
                    try {
                      if (isEditing) {
                        await provider.updatePost(
                          widget.post!.id, 
                          _titleController.text, 
                          _bodyController.text
                        );
                      } else {
                        await provider.addPost(
                          _titleController.text, 
                          _bodyController.text
                        );
                      }
                      
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isEditing ? "Post updated successfully" : "Post created successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.errorMessage ?? "Operation failed"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text(isEditing ? "Update" : "Create"),
              )
            ],
          ),
        ),
      ),
    );
  }
}