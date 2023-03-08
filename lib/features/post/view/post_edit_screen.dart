import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_new/features/post/controller/edit_post_controller.dart';
import 'package:riverpod_new/features/post/model/post.dart';
import 'package:riverpod_new/features/post/repository/post_repository.dart';

class PostEditScreen extends ConsumerWidget {
  const PostEditScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPost = ref.watch(postProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: Text('post edit $id'),
      ),
      body: asyncPost.when(
        data: (post) => EditPostDetailsForm(post: post),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class EditPostDetailsForm extends ConsumerStatefulWidget {
  const EditPostDetailsForm({super.key, required this.post});
  final Post post;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditPostDetailsFormState();
}

class _EditPostDetailsFormState extends ConsumerState<EditPostDetailsForm> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.post.title;
    _bodyController.text = widget.post.body;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editPostControllerProvider);
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Builder(builder: (context) {
        return Builder(builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bodyController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () => ref
                        .read(editPostControllerProvider.notifier)
                        .updatePost(
                          previousPost: widget.post,
                          title: _titleController.text,
                          body: _bodyController.text,
                          onSuccess: Navigator.of(context).pop,
                        ),
                child: const Text('Submit'),
              )
            ],
          );
        });
      }),
    );
  }
}
