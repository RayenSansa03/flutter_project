import 'package:dartz/dartz.dart' hide Task;
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/daily_planner/domain/entities/task.dart';
import 'package:projet_flutter/features/daily_planner/domain/repositories/daily_planner_repository.dart';

class AddTaskUseCase {
  final DailyPlannerRepository repository;

  AddTaskUseCase(this.repository);

  Future<Either<Failure, Task>> call(Task task) async {
    return await repository.addTask(task);
  }
}

class UpdateTaskUseCase {
  final DailyPlannerRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<Either<Failure, Task>> call(Task task) async {
    return await repository.updateTask(task);
  }
}

class DeleteTaskUseCase {
  final DailyPlannerRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<Either<Failure, void>> call(String taskId) {
    return repository.deleteTask(taskId);
  }
}


class GenerateTasksUseCase {
  final DailyPlannerRepository repository;

  GenerateTasksUseCase(this.repository);

  Future<Either<Failure, List<Task>>> call(String prompt) async {
    return await repository.generateTasksFromPrompt(prompt);
  }
}
