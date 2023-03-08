import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final _authStateController = StreamController<bool>();
  Stream<bool> authStateChanges() => _authStateController.stream;

  AuthRepository() {
    print('AuthRepository constructor');
    _authStateController.add(false);
  }

  Future<void> signIn() async {
    await Future.delayed(const Duration(seconds: 1));
    //throw 'error'; //테스트 에러 날려 보기
    _authStateController.add(true);
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    _authStateController.add(false);
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository();
}

@Riverpod(keepAlive: true)
Stream<bool> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.authStateChanges();
}
