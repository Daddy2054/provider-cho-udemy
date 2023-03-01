// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fb_statenf_auth/models/custom_error.dart';
import 'package:fb_statenf_auth/providers/signup/signup_state.dart';
import 'package:fb_statenf_auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_notifier/state_notifier.dart';

class SignupProvider extends  StateNotifier<SignupState> with LocatorMixin {
  SignupProvider():super(SignupState.initial());

  // SignupState _state = SignupState.initial();
  // SignupState get state => _state;

  // final AuthRepository authRepository;
  // SignupProvider({
  //   required this.authRepository,
  // });

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(signupStatus: SignupStatus.submitting);
    try {
      await read<AuthRepository>().signup(name: name, email: email, password: password);
      state = state.copyWith(signupStatus: SignupStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(signupStatus: SignupStatus.error, error: e);
      rethrow;
    }
  }
}
