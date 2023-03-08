import 'dart:async';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_new/dio_provider.dart';
import 'package:riverpod_new/features/todo/model/todo.dart';
part 'todo_repository.g.dart';

@riverpod
TodoRepository todoRepository(TodoRepositoryRef ref) {
  return TodoRepository(ref.read(dioProvider),
      baseUrl: 'https://jsonplaceholder.typicode.com');
}

@RestApi()
abstract class TodoRepository {
  factory TodoRepository(Dio dio, {String baseUrl}) = _TodoRepository;
  @GET('/todos')
  Future<List<Todo>> fetchTodos();

  @GET('/todos/{id}')
  Future<Todo> fetchTodo({
    @Path('id') required String id,
    @CancelRequest() CancelToken? cancelToken,
  });
}

//auto dispose
@riverpod
Future<List<Todo>> todos(TodosRef ref) {
  return ref.watch(todoRepositoryProvider).fetchTodos().catchError(
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

//auto dispose
@riverpod
Future<Todo> todo(TodoRef ref, int id) {
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
      .watch(todoRepositoryProvider)
      .fetchTodo(id: id.toString(), cancelToken: cancelToken)
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
