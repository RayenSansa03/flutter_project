import 'package:dartz/dartz.dart' hide Task;
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/daily_planner/domain/entities/task.dart';
import 'package:projet_flutter/features/daily_planner/domain/repositories/daily_planner_repository.dart';

class GetTasksUseCase {
  final DailyPlannerRepository repository;

  GetTasksUseCase(this.repository);

  Future<Either<Failure, List<Task>>> call() async {
    return await repository.getTasks();
  }
}
