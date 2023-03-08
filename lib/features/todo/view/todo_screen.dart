import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_new/features/todo/repository/todo_repository.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTodos = ref.watch(todosProvider);
    return Scaffold(
      appBar: AppBar(title: Text('todo')),
      body: asyncTodos.when(
        data: (todos) => ListView.separated(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return GestureDetector(
              onTap: () {
                context.go('/todo/detail/${todo.id}');
              },
              child: ListTile(
                title: Text(todo.title),
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
