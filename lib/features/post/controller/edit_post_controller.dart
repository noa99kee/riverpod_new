import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_new/features/post/model/post.dart';
import 'package:riverpod_new/features/post/repository/post_repository.dart';

part 'edit_post_controller.g.dart';

@riverpod
class EditPostController extends _$EditPostController {
  bool mounted = true;
  @override
  FutureOr<void> build() {
    ref.onDispose(() {
      print('editPostControllerProvider onDispose');
      mounted = false;
    });
  }

  Future<void> updatePost({
    required Post previousPost,
    required String title,
    required String body,
    required void Function() onSuccess,
  }) async {
    print('updatePost');
    // * if nothing has changed, return early
    if (previousPost.title == title && previousPost.body == body) {
      onSuccess();
      return;
    }
    state = const AsyncLoading();
    final updated = previousPost.copyWith(title: title, body: body);
    final postRepository = ref.read(postRepositoryProvider);
    final newState = await AsyncValue.guard(() =>
        postRepository.updatePost(id: updated.id.toString(), post: updated));
    // on success, invalidate the FutureProvider that fetches the post data

    if (newState is AsyncData) {
      print('newState is AsyncData');
      ref.invalidate(postProvider(updated.id));
    }
    if (mounted) {
      // * only set the state if the controller hasn't been disposed
      state = newState;
      if (state.hasError == false) {
        onSuccess();
      }
    }
  }
}
