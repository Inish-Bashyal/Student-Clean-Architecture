import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/core/common/snackbar/my_snackbar.dart';
import 'package:student_clean_arch/features/course/domain/entity/course_entity.dart';
import 'package:student_clean_arch/features/course/presentation/viewmodel/course_viewmodel.dart';

import '../widget/load_course.dart';

class AddCourseView extends ConsumerStatefulWidget {
  const AddCourseView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCourseViewState();
}

class _AddCourseViewState extends ConsumerState<AddCourseView> {
  final courseController = TextEditingController();
  var gap = const SizedBox(height: 8);
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var courseState = ref.watch(courseViewModelProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              gap,
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Add Course',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              gap,
              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Course Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter course name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      var course = CourseEntity(
                        courseName: courseController.text,
                      );

                      ref
                          .read(courseViewModelProvider.notifier)
                          .addCourse(course);
                      if (courseState.error != null) {
                        showSnackBar(
                          message: courseState.error.toString(),
                          context: context,
                          color: Colors.red,
                        );
                      } else {
                        showSnackBar(
                          message: 'Course added successfully',
                          context: context,
                        );
                      }
                    }
                  },
                  child: const Text('Add Course'),
                ),
              ),
              gap,
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'List of Courses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              gap,
              if (courseState.isLoading) ...{
                const CircularProgressIndicator(),
              } else if (courseState.error != null) ...{
                Text(courseState.error!),
              } else if (courseState.courses.isNotEmpty) ...{
                Expanded(
                  child: LoadCourse(
                    lstCourse: courseState.courses,
                    ref: ref,
                  ),
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
