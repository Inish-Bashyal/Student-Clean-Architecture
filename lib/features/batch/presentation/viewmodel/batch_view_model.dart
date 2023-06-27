import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/core/common/snackbar/my_snackbar.dart';
import 'package:student_clean_arch/features/batch/domain/entity/batch_entity.dart';
import 'package:student_clean_arch/features/batch/domain/use_case/batch_use_case.dart';
import 'package:student_clean_arch/features/batch/presentation/state/batch_state.dart';
import 'package:student_clean_arch/features/course/domain/entity/course_entity.dart';

final batchViewModelProvider =
    StateNotifierProvider<BatchViewModel, BatchState>(
  (ref) => BatchViewModel(ref.read(batchUsecaseProvider)),
);

class BatchViewModel extends StateNotifier<BatchState> {
  final BatchUseCase batchUseCase;

  BatchViewModel(this.batchUseCase) : super(BatchState.initial()) {
    getAllBatches();
  }

  addBatch(BatchEntity batch) async {
    state.copyWith(isLoading: true);
    var data = await batchUseCase.addBatch(batch);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  getAllBatches() async {
    state = state.copyWith(isLoading: true);
    var data = await batchUseCase.getAllBatches();

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, batches: r, error: null),
    );
  }

  Future<void> deleteCourse(BuildContext context, BatchEntity batch) async {
    state.copyWith(isLoading: true);
    var data = await batchUseCase.deleteBatch(batch.batchId!);

    data.fold(
      (l) {
        showSnackBar(message: l.error, context: context, color: Colors.red);

        state = state.copyWith(isLoading: false, error: l.error);
      },
      (r) {
        state.batches.remove(batch);
        state = state.copyWith(isLoading: false, error: null);
        showSnackBar(
          message: 'Batch delete successfully',
          context: context,
        );
      },
    );
  }
}
