// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fb_statenf_auth/models/custom_error.dart';
import 'package:fb_statenf_auth/providers/signin/signin_state.dart';
import 'package:fb_statenf_auth/repositories/auth_repository.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class SigninProvider extends StateNotifier<SigninState> with LocatorMixin {
  SigninProvider() : super(SigninState.initial());

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(signinStatus: SigninStatus.submitting);
    try {
      await read<AuthRepository>().signin(email: email, password: password);
      state = state.copyWith(signinStatus: SigninStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(signinStatus: SigninStatus.error, error: e);
      rethrow;
    }
  }
}
