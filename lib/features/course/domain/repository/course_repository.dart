import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/core/failure/failure.dart';
import 'package:student_clean_arch/features/course/data/repository/course_remote_repo_provider.dart';
import 'package:student_clean_arch/features/course/domain/entity/course_entity.dart';

final courseRepositoryProvider = Provider<ICourseRepository>(
  (ref) {
    return ref.read(courseRemoteRepoProvider);
  },
);

abstract class ICourseRepository {
  Future<Either<Failure, bool>> addCourse(CourseEntity course);
  Future<Either<Failure, List<CourseEntity>>> getAllCourses();
}
