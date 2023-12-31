import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/core/common/snackbar/my_snackbar.dart';
import 'package:student_clean_arch/features/batch/domain/entity/batch_entity.dart';
import 'package:student_clean_arch/features/batch/presentation/viewmodel/batch_view_model.dart';
import 'package:student_clean_arch/features/batch/presentation/widget/load_batch.dart';

class AddBatchView extends ConsumerStatefulWidget {
  const AddBatchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddBatchViewState();
}

class _AddBatchViewState extends ConsumerState<AddBatchView> {
  final batchController = TextEditingController();
  var gap = const SizedBox(height: 8);
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var battchState = ref.watch(batchViewModelProvider);
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
                  'Add Batch',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              gap,
              TextFormField(
                controller: batchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Batch Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter batch name';
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
                      var batch = BatchEntity(
                        batchName: batchController.text,
                      );

                      ref.read(batchViewModelProvider.notifier).addBatch(batch);
                      if (battchState.error != null) {
                        showSnackBar(
                          message: battchState.error.toString(),
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
              gap,
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'List of Batches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              gap,
              if (battchState.isLoading) ...{
                const CircularProgressIndicator(),
              } else if (battchState.error != null) ...{
                Text(battchState.error!),
              } else if (battchState.batches.isNotEmpty) ...{
                Expanded(
                  child: LoadBatch(
                    lstBatch: battchState.batches,
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
