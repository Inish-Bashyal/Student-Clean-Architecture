import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/core/failure/failure.dart';
import 'package:student_clean_arch/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:student_clean_arch/features/auth/domain/entity/student_entity.dart';
import 'package:student_clean_arch/features/auth/domain/repository/auth_repository.dart';

final authRemoteRepoProvider = Provider<IAuthRepository>((ref) {
  return AuthRemoteRepository(ref.read(authRemoteDataSourceProvider));
});

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRemoteRepository(this._authRemoteDataSource);
  @override
  Future<Either<Failure, bool>> loginStudent(String username, String password) {
    return _authRemoteDataSource.loginStudent(username, password);
  }

  @override
  Future<Either<Failure, bool>> registerStudent(StudentEntity student) {
    return _authRemoteDataSource.registerStudent(student);
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) {
    return _authRemoteDataSource.uploadProfilePicture(file);
  }
}
