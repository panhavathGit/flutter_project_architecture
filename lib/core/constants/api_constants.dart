class ApiConstants {
  // Prevent instantiation
  ApiConstants._();

  // Local backend (for development)
  // static const String baseUrl = 'http://localhost:3001';

  // For Android Emulator - use 10.0.2.2 instead of localhost
  static const String baseUrl = 'http://10.0.2.2:3001';
  
  // For iOS Simulator - use localhost
  // static const String baseUrl = 'http://localhost:3001';
  
  // For Physical Device - use your computer's IP
  // static const String baseUrl = 'http://192.168.x.x:3001';

  // Endpoints
  static const String posts = '$baseUrl/api/posts';
  static const String comments = '$baseUrl/comments';
  static const String users = '$baseUrl/users';

  static const String health = '$baseUrl/health';

}