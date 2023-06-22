import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_clean_arch/core/failure/failure.dart';
import 'package:student_clean_arch/features/batch/data/repository/batch_remote_repo_provider.dart';
import 'package:student_clean_arch/features/batch/domain/entity/batch_entity.dart';

final batchRepositoryProvider = Provider<IBatchRepository>((ref) {
  // Return Local repository implementation
  // For internet connectivity we will check later
  return ref.read(batchRemoteRepoProvider);
});

abstract class IBatchRepository {
  Future<Either<Failure, List<BatchEntity>>> getAllBatches();
  Future<Either<Failure, bool>> addBatch(BatchEntity batch);
}
