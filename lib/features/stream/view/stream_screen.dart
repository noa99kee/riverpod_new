import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_new/features/stream/repository/stream_repository.dart';

class StreamScreen extends ConsumerWidget {
  const StreamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMovies = ref.watch(streamMoviesProvider);
    return Scaffold(
      appBar: AppBar(title: Text('stream')),
      body: asyncMovies.when(
        data: (movies) => ListView.separated(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return GestureDetector(
              onTap: () {},
              child: ListTile(
                title: Text('${movie.id}  ${movie.title}'),
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
