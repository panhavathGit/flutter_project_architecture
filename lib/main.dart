import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// UPDATE THESE IMPORTS to match the new Feature-First structure
import 'features/posts/data/datasources/post_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/usecases/get_posts_usecase.dart';
import 'features/posts/presentation/providers/post_provider.dart';
import 'features/posts/presentation/pages/post_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The LOGIC here remains exactly the same as before.
    // We are still doing Manual Injection (Simple & understandable).
    
    // 1. Data Layer
    final postRemoteDataSource = PostRemoteDataSource();
    final postRepository = PostRepositoryImpl(postRemoteDataSource);
    
    // 2. Domain Layer
    final getPostsUseCase = GetPostsUseCase(postRepository);

    return MultiProvider(
      providers: [
        // 3. Presentation Layer
        ChangeNotifierProvider(
          create: (_) => PostProvider(getPostsUseCase: getPostsUseCase),
        ),
      ],
      child: MaterialApp(
        title: 'Feature First Architecture',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const PostPage(),
      ),
    );
  }
}