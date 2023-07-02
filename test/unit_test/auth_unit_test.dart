import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_clean_arch/core/failure/failure.dart';
import 'package:student_clean_arch/features/auth/domain/use_case/auth_usecase.dart';
import 'package:student_clean_arch/features/auth/presentation/viewmodel/auth_view_model.dart';

import 'auth_unit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthUseCase>(),
  MockSpec<BuildContext>(),
])
void main() {
  late AuthUseCase mockAuthUseCase;
  late ProviderContainer container;
  late BuildContext context;

  setUpAll(() {
    mockAuthUseCase = MockAuthUseCase();
    context = MockBuildContext();
    container = ProviderContainer(
      overrides: [
        authViewModelProvider.overrideWith(
          (ref) => AuthViewModel(mockAuthUseCase),
        ),
      ],
    );
  });

  test('Check For Initial State is Loading', () async {
    final authState = container.read(authViewModelProvider);
    expect(authState.isLoading, false);
    expect(authState.error, isNull);
    expect(authState.imageName, isNull);
  });

  test('Login Test with valid Username and Password', () async {
    //when username is Inish and password is Inish123 then only there is no error
    when(mockAuthUseCase.loginStudent('Inish', 'Inish123'))
        .thenAnswer((_) => Future.value(const Right(true)));
    await container
        .read(authViewModelProvider.notifier)
        .loginStudent(context, 'Inish', "Inish123");

    final authState = container.read(authViewModelProvider);

    expect(authState.error, isNull);

    tearDownAll(() {
      container.dispose();
    });
  });

  test('Login Test with invalid Username and Password', () async {
    //when username is Inish and password is Inish123 then only there is no error
    when(mockAuthUseCase.loginStudent('Inish', 'Inish1234'))
        .thenAnswer((_) => Future.value(Left(Failure(error: 'Invalid'))));
    await container
        .read(authViewModelProvider.notifier)
        .loginStudent(context, 'Inish', "Inish1234");

    final authState = container.read(authViewModelProvider);

    expect(authState.error, 'Invalid');

    tearDownAll(() {
      container.dispose();
    });
  });
}
