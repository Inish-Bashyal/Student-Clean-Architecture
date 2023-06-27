import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/features/batch/domain/entity/batch_entity.dart';
import 'package:student_clean_arch/features/batch/presentation/viewmodel/batch_view_model.dart';
import 'package:student_clean_arch/features/course/domain/entity/course_entity.dart';

class LoadBatch extends StatelessWidget {
  final WidgetRef ref;
  final List<BatchEntity> lstBatch;
  const LoadBatch({super.key, required this.lstBatch, required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lstBatch.length,
      itemBuilder: ((context, index) => ListTile(
          title: Text(lstBatch[index].batchName),
          subtitle: Text(lstBatch[index].batchName),
          trailing: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                      'Are you sure you want to delete ${lstBatch[index].batchName}?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ref
                              .read(batchViewModelProvider.notifier)
                              .deleteCourse(context, lstBatch[index]);
                        },
                        child: const Text('Yes')),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ))),
    );
  }
}
