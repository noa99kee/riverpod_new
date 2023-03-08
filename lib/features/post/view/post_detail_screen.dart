import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_new/features/post/repository/post_repository.dart';

class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({super.key, required this.id});
  final int id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPost = ref.watch(postProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text('post detail ${id}')),
      body: asyncPost.when(
        data: (post) => Center(
          child: Column(children: [
            Text(
              post.title,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
            ),
            Divider(),
            Text(
              post.body,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text('Edit'),
              onPressed: () {
                context.go('/post/edit/${post.id}');
              },
            )
          ]),
        ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
