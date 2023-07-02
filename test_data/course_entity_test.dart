import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:student_clean_arch/features/course/domain/entity/course_entity.dart';

Future<List<CourseEntity>> getCourseListTest() async {
  final response =
      await rootBundle.loadString('test_data/course_test_data.json');
  final jsonList = await json.decode(response);
  final List<CourseEntity> courseList = jsonList
      .map<CourseEntity>((json) => CourseEntity.fromJson(json))
      .toList();

  return Future.value(courseList);
}
