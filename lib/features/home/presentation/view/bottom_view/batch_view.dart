import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/core/common/snackbar/my_snackbar.dart';
import 'package:student_clean_arch/features/batch/domain/entity/batch_entity.dart';
import 'package:student_clean_arch/features/batch/presentation/viewmodel/batch_view_model.dart';
import 'package:student_clean_arch/features/home/presentation/widget/batch_widget.dart';

class BatchView extends ConsumerStatefulWidget {
  const BatchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BatchViewState();
}

class _BatchViewState extends ConsumerState<BatchView> {
  final _batchController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final _gap = const SizedBox(height: 8);

  @override
  Widget build(BuildContext context) {
    final batchState = ref.watch(batchViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch View'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: _batchController,
                decoration: const InputDecoration(
                  labelText: 'Batch Name',
                ),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter batch name';
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
                      var batch = BatchEntity(
                        batchName: _batchController.text,
                      );

                      ref.read(batchViewModelProvider.notifier).addBatch(batch);

                      if (batchState.error != null) {
                        showSnackBar(
                          message: batchState.error.toString(),
                          context: context,
                          color: Colors.red,
                        );
                      } else {
                        showSnackBar(
                          message: 'Batch added successfully',
                          context: context,
                        );
                      }
                    }
                  },
                  child: const Text('Add Batch'),
                ),
              ),
              _gap,
              Flexible(
                child: BatchWidget(batchList: batchState.batches),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
