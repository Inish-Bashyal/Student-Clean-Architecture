import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/core/failure/failure.dart';
import 'package:student_clean_arch/core/network/remote/api_endpoint.dart';
import 'package:student_clean_arch/core/network/remote/http_service.dart';
import 'package:student_clean_arch/core/shared_prefs/user_shared_prefs.dart';
import 'package:student_clean_arch/features/course/data/dto/get_all_course_dto.dart';
import 'package:student_clean_arch/features/course/data/model/course_api_model.dart';
import 'package:student_clean_arch/features/course/domain/entity/course_entity.dart';

final courseRemoteDataSourceProvider = Provider(
  (ref) => CourseRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    courseApiModel: ref.read(courseApiModelProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class CourseRemoteDataSource {
  final Dio dio;
  final CourseApiModel courseApiModel;
  final UserSharedPrefs userSharedPrefs;

  CourseRemoteDataSource({
    required this.dio,
    required this.courseApiModel,
    required this.userSharedPrefs,
  });

  Future<Either<Failure, bool>> addCourse(CourseEntity course) async {
    try {
      var response = await dio.post(
        ApiEndpoints.createCourse,
        data: courseApiModel.fromEntity(course).toJson(),
      );

      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.message.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, List<CourseEntity>>> getAllCourses() async {
    try {
      var response = await dio.get(ApiEndpoints.getAllCourse);
      if (response.statusCode == 200) {
        // OR
        // 2nd way
        GetAllCourseDTO courseAddDTO = GetAllCourseDTO.fromJson(response.data);
        return Right(courseApiModel.toEntityList(courseAddDTO.data));
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, bool>> deleteCourse(String courseId) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      Response response = await dio.delete(
        ApiEndpoints.deleteCourse + courseId,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}



//  // 1st way
//         var batches = (response.data['data'] as List)
//             .map((course) => CourseApiModel.fromJson(course).toEntity())
//             .toList();
//         return Right(batches);