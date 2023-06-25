import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/config/router/app_route.dart';
import 'package:student_clean_arch/core/failure/failure.dart';
import 'package:student_clean_arch/core/shared_prefs/user_shared_prefs.dart';

final splashViewModelProvider = Provider(
  (ref) => SplashViewModel(
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class SplashViewModel {
  final UserSharedPrefs userSharedPrefs;

  SplashViewModel({required this.userSharedPrefs});
  Future<bool> checkTokenAndRedirect(BuildContext context) async {
    // Simulate an asynchronous token check
    await Future.delayed(const Duration(seconds: 2));
    Future<Either<Failure, String?>> userToken = userSharedPrefs.getUserToken();

    // ignore: unnecessary_null_comparison
    if (userToken != null) {
      Navigator.popAndPushNamed(context, AppRoute.homeRoute);
      return true;
    } else {
      Navigator.popAndPushNamed(context, AppRoute.loginRoute);
      return false;
    }
  }
}
