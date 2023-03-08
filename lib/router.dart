import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_new/features/auth/view/auth_screen.dart';
import 'package:riverpod_new/features/post/view/post_detail_screen.dart';
import 'package:riverpod_new/features/post/view/post_edit_screen.dart';
import 'package:riverpod_new/features/post/view/post_screen.dart';
import 'package:riverpod_new/features/todo/view/todo_detail_screen.dart';
import 'package:riverpod_new/features/todo/view/todo_screen.dart';
import 'package:riverpod_new/home_screen.dart';
part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: HomeScreen()),
          routes: [
            GoRoute(
              path: 'auth',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: AuthScreen()),
            ),
            GoRoute(
              path: 'todo',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: TodoScreen()),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  pageBuilder: (context, state) => NoTransitionPage(
                      child: TodoDetailScreen(
                    id: int.parse(state.params['id']!),
                  )),
                )
              ],
            ),
            GoRoute(
              path: 'post',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: PostScreen()),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  pageBuilder: (context, state) => NoTransitionPage(
                      child: PostDetailScreen(
                    id: int.parse(state.params['id']!),
                  )),
                ),
                GoRoute(
                  path: 'edit/:id',
                  pageBuilder: (context, state) => NoTransitionPage(
                      child: PostEditScreen(
                    id: int.parse(state.params['id']!),
                  )),
                ),
              ],
            ),
          ],
        ),
      ],
    );
