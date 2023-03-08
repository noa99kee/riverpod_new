import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_new/features/todo/repository/todo_repository.dart';

class TodoDetailScreen extends ConsumerWidget {
  const TodoDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTodo = ref.watch(todoProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text('todo detail')),
      body: asyncTodo.when(
        data: (todo) => Center(
          child: Column(children: [
            Text(
              todo.title,
              style: TextStyle(fontSize: 24),
            ),
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
