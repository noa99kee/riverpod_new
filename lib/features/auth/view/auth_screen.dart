import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_new/features/auth/controller/auth_controller.dart';
import 'package:riverpod_new/features/auth/repository/auth_repository.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAuthState = ref.watch(authStateChangesProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('auth')),
        body: Center(
          child: asyncAuthState.when(
            data: (signIn) {
              if (signIn) {
                return const SignInWidget();
              } else {
                return const SignOutWidget();
              }
            },
            error: (e, st) => Center(child: Text(e.toString())),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ));
  }
}

class SignInWidget extends ConsumerWidget {
  const SignInWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(authControllerProvider).isLoading) {
      return const CircularProgressIndicator();
    }
    if (ref.watch(authControllerProvider).hasError) {
      return const Center(child: Text('SignIn 에러'));
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('로그인 상태'),
          ElevatedButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut();
              },
              child: const Text('Sign Out')),
        ],
      ),
    );
  }
}

class SignOutWidget extends ConsumerWidget {
  const SignOutWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(authControllerProvider).isLoading) {
      return const CircularProgressIndicator();
    }

    if (ref.watch(authControllerProvider).hasError) {
      return const Center(child: Text('SignOut 에러'));
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('로그아웃 상태'),
          ElevatedButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).signIn();
              },
              child: const Text('Sign In')),
        ],
      ),
    );
  }
}
