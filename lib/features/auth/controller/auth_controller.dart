import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_new/features/auth/repository/auth_repository.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  late final AuthRepository _repository;
  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepositoryProvider);
  }

  Future<void> signIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.signIn(),
    );
    if (state.hasError) {
      print('signIn has error');
    } else {
      print('signIn ok');
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _repository.signOut(),
    );
    if (state.hasError) {
      print('signOut has error');
    } else {
      print('signOut ok');
    }
  }
}
