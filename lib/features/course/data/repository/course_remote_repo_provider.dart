import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/features/course/data/data_source/course_remote_data_source.dart';
import 'package:student_clean_arch/features/course/domain/entity/course_entity.dart';
import 'package:student_clean_arch/features/course/domain/repository/course_repository.dart';

import '../../../../core/failure/failure.dart';

final courseRemoteRepoProvider = Provider<ICourseRepository>(
  (ref) => CourseRemoteRepositoryImpl(
    courseRemoteDataSource: ref.read(courseRemoteDataSourceProvider),
  ),
);

class CourseRemoteRepositoryImpl implements ICourseRepository {
  final CourseRemoteDataSource courseRemoteDataSource;

  CourseRemoteRepositoryImpl({required this.courseRemoteDataSource});

  @override
  Future<Either<Failure, bool>> addCourse(CourseEntity course) {
    return courseRemoteDataSource.addCourse(course);
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getAllCourses() {
    return courseRemoteDataSource.getAllCourses();
  }
}
