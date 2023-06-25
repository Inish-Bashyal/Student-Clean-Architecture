import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/core/common/snackbar/my_snackbar.dart';
import 'package:student_clean_arch/features/course/domain/entity/course_entity.dart';
import 'package:student_clean_arch/features/course/presentation/viewmodel/course_viewmodel.dart';
import 'package:student_clean_arch/features/home/presentation/widget/course_widget.dart';

class CourseView extends ConsumerStatefulWidget {
  const CourseView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseViewState();
}

class _CourseViewState extends ConsumerState<CourseView> {
  final _courseController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final _gap = const SizedBox(height: 8);

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course View'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _courseController,
              decoration: const InputDecoration(
                labelText: 'Course Name',
              ),
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter first name';
                }
                return null;
              }),
            ),
            _gap,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    var course = CourseEntity(
                      courseName: _courseController.text,
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
            _gap,
            Flexible(
              child: CourseWidget(courseList: courseState.courses),
            ),
          ],
        ),
      ),
    );
  }
}
