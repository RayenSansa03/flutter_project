import 'package:dartz/dartz.dart' hide Task;
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/daily_planner/domain/entities/task.dart';

abstract class DailyPlannerRepository {
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, Task>> addTask(Task task);
  Future<Either<Failure, Task>> updateTask(Task task);
  Future<Either<Failure, void>> deleteTask(String taskId);
  Future<Either<Failure, List<Task>>> generateTasksFromPrompt(String prompt);
}
