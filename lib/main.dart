import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- Imports for Feature 1: Posts ---
import 'features/posts/data/datasources/post_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/usecases/get_posts_usecase.dart';
import 'features/posts/presentation/providers/post_provider.dart';
import 'features/posts/presentation/pages/post_page.dart';

// --- Imports for Feature 2: Comments ---
import 'features/comments/data/datasources/comment_remote_data_source.dart';
import 'features/comments/data/repositories/comment_repository_impl.dart';
import 'features/comments/domain/usecases/get_comments_usecase.dart';
import 'features/comments/presentation/providers/comment_provider.dart';

// --- Imports for feature 3: CRUD post ---
import 'features/posts/domain/usecases/add_post_usecase.dart';
import 'features/posts/domain/usecases/update_post_usecase.dart';
import 'features/posts/domain/usecases/delete_post_usecase.dart';

import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ------------------------------------
    // 1. INJECTION FOR FEATURE: POSTS
    // ------------------------------------

    // 1. Data Layer
    final postDataSource = PostRemoteDataSource();
    final postRepository = PostRepositoryImpl(postDataSource);

    // 2. Domain Layer (4 UseCases)
    final getPostsUseCase = GetPostsUseCase(postRepository);
    final addPostUseCase = AddPostUseCase(postRepository);
    final updatePostUseCase = UpdatePostUseCase(postRepository);
    final deletePostUseCase = DeletePostUseCase(postRepository);

    // ------------------------------------
    // 2. INJECTION FOR FEATURE: COMMENTS
    // ------------------------------------
    final commentDataSource = CommentRemoteDataSource();
    final commentRepository = CommentRepositoryImpl(commentDataSource);

    final getCommentsUseCase = GetCommentsUseCase(commentRepository);

    return MultiProvider(
      providers: [
        // Provider 1: Posts
        ChangeNotifierProvider(
          create: (_) => PostProvider(
            getPostsUseCase: getPostsUseCase,
            addPostUseCase: addPostUseCase,
            updatePostUseCase: updatePostUseCase,
            deletePostUseCase: deletePostUseCase
            ),
        ),
        
        // Provider 2: Comments (We add this here so it's available app-wide)
        // Note: For very large apps, we might only provide this when opening the page,
        // but for now, putting it here is perfectly fine.
        ChangeNotifierProvider(
          create: (_) => CommentProvider(getCommentsUseCase: getCommentsUseCase),
        ),
      ],
      child: MaterialApp(
        title: 'Social App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true, // Let's look modern
        ),
        // CHANGE THIS LINE:
        home: const MainScreen(),
      ),
    );
  }
}