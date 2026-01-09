import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/post_remote_data_source.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'presentation/providers/post_provider.dart';
import 'presentation/pages/post_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Create the Data Source
    final postRemoteDataSource = PostRemoteDataSource();
    
    // 2. Create the Repository (injecting Data Source)
    final postRepository = PostRepositoryImpl(postRemoteDataSource);
    
    // 3. Create the UseCase (injecting Repository)
    final getPostsUseCase = GetPostsUseCase(postRepository);

    return MultiProvider(
      providers: [
        // 4. Create the Provider (injecting UseCase)
        ChangeNotifierProvider(
          create: (_) => PostProvider(getPostsUseCase: getPostsUseCase),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Clean Architecture',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const PostPage(),
      ),
    );
  }
}