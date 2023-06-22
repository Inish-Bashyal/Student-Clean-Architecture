import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/config/router/app_route.dart';
import 'package:student_clean_arch/core/common/snackbar/my_snackbar.dart';
import 'package:student_clean_arch/features/auth/domain/entity/student_entity.dart';
import 'package:student_clean_arch/features/auth/domain/use_case/auth_usecase.dart';
import 'package:student_clean_arch/features/auth/presentation/state/auth_state.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(
    ref.read(authUseCaseProvider),
  );
});

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthUseCase _authUseCase;

  AuthViewModel(this._authUseCase) : super(AuthState(isLoading: false));

  Future<void> registerStudent(StudentEntity student) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.registerStudent(student);
    data.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.error,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        error: null,
      ),
    );
  }

  Future<bool> loginStudent(
      BuildContext context, username, String password) async {
    state = state.copyWith(isLoading: true);
    bool isLogin = false;
    var data = await _authUseCase.loginStudent(username, password);
    data.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.error);
        showSnackBar(
          message: 'Invalid Credentials',
          context: context,
          color: Colors.red,
        );
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        Navigator.popAndPushNamed(context, AppRoute.homeRoute);
      },
    );

    return isLogin;
  }

  Future<void> uploadImage(File? file) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.uploadProfilePicture(file!);
    data.fold(
      (l) => state = state.copyWith(
        isLoading: false,
        error: l.error,
      ),
      (imageName) => state = state.copyWith(
        isLoading: false,
        imageName: imageName,
      ),
    );
  }
}
