import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/core/failure/failure.dart';
import 'package:student_clean_arch/features/auth/data/repository/auth_remote_repository.dart';
import 'package:student_clean_arch/features/auth/domain/entity/student_entity.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return ref.read(authRemoteRepoProvider);
});

abstract class IAuthRepository {
  Future<Either<Failure, bool>> registerStudent(StudentEntity student);
  Future<Either<Failure, bool>> loginStudent(String username, String password);
  Future<Either<Failure, String>> uploadProfilePicture(File file);
}
