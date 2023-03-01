// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:fb_statenf_auth/providers/auth/auth_state.dart';
import 'package:fb_statenf_auth/repositories/auth_repository.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';

class AuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  AuthProvider() : super(AuthState.unknown());

  @override
  void update(Locator watch) {
    final user = watch<fbAuth.User?>();

    if (user != null) {
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: user,
      );
    } else {
      state = state.copyWith(
        authStatus: AuthStatus.unauthenticated,
      );
    }
    print('authState: $state');

    super.update(watch);
  }

  void signout() async {
    await read<AuthRepository>().signout();
  }
}
