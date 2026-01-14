class Post {
  final int id;
  final String title;
  final String content;  // Changed from 'body' to match backend
  final String author;   // Added author field
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.author = 'Anonymous',
    this.createdAt,
    this.updatedAt,
  });

  // Backward compatibility getter
  String get body => content;
}