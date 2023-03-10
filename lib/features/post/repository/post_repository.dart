import 'dart:async';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_new/dio_provider.dart';
import 'package:riverpod_new/features/post/model/post.dart';
import 'package:riverpod_new/features/todo/repository/todo_repository.dart';

part 'post_repository.g.dart';

@riverpod
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepository(ref.read(dioProvider),
      baseUrl: 'https://jsonplaceholder.typicode.com');
}

@RestApi()
abstract class PostRepository {
  factory PostRepository(Dio dio, {String baseUrl}) = _PostRepository;
  @GET('/posts')
  Future<List<Post>> fetchPosts();

  @GET('/posts/{id}')
  Future<Post> fetchPost({
    @Path('id') required String id,
    @CancelRequest() CancelToken? cancelToken,
  });

  @PUT('/posts/{id}')
  Future<void> updatePost({
    @Path('id') required String id,
    @Body() required Post post,
    @CancelRequest() CancelToken? cancelToken,
  });
}

//auto dispose
@riverpod
Future<List<Post>> posts(PostsRef ref) async {
  print('postsProvider');
  //프로바이더 안에서 다른 프로바이더 호출
  final todos = await ref.watch(todosProvider.future);
  //print('todos:$todos');

  //미리 200개 불러 오기 가능 다중 요청 병렬 처리(모든 요청을 다 보내놓고 결과를 기다림)
  DateTime start = DateTime.now();
  await Future.wait(
      [for (final todo in todos) ref.watch(todoProvider(todo.id).future)]);
  DateTime end = DateTime.now();
  print('소요 시간 : ${end.difference(start)}');
  return ref.watch(postRepositoryProvider).fetchPosts().catchError(
    (Object obj) {
      //에러 처리
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          throw ("Got error : ${res?.statusCode} -> ${res?.statusMessage}");
        default:
          break;
      }
    },
  ).then((posts) {
    print('#################################');
    print('posts:$posts');
    return posts;
  });
}

//auto dispose
@riverpod
Future<Post> post(PostRef ref, int id) {
  final link = ref.keepAlive();
  Timer? timer;
  final CancelToken cancelToken = CancelToken();

  ref.onDispose(() {
    print('todoProvider onDispose');
    cancelToken.cancel();
    timer?.cancel();
  });

  ref.onCancel(() {
    print('todoProvider onCancel');
    timer = Timer(const Duration(seconds: 5), () {
      link.close();
    });
  });

  ref.onResume(() {
    print('todoProvider onResume');
    timer?.cancel();
  });

  return ref
      .watch(postRepositoryProvider)
      .fetchPost(id: id.toString(), cancelToken: cancelToken)
      .catchError(
    (Object obj) {
      //에러 처리
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          throw ("Got error : ${res?.statusCode} -> ${res?.statusMessage}");
        default:
          break;
      }
    },
  );
}
