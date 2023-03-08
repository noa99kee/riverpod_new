import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_new/features/post/repository/post_repository.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(postsProvider);
    return Scaffold(
      appBar: AppBar(title: Text('post')),
      body: asyncPosts.when(
        data: (posts) => ListView.separated(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return GestureDetector(
              onTap: () {
                context.go('/post/detail/${post.id}');
              },
              child: ListTile(
                title: Text('${post.id}  ${post.title}'),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
