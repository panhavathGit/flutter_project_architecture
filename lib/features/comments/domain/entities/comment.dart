class Comment {
  final int id;
  final String name; // The commenter's name
  final String email;
  final String body;

  Comment({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.body
  });
}