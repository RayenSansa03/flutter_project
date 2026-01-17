import 'package:dartz/dartz.dart' hide Task;
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/daily_planner/data/datasources/daily_planner_remote_datasource.dart';
import 'package:projet_flutter/features/daily_planner/data/models/task_model.dart';
import 'package:projet_flutter/features/daily_planner/domain/entities/task.dart';
import 'package:projet_flutter/features/daily_planner/domain/repositories/daily_planner_repository.dart';

class DailyPlannerRepositoryImpl implements DailyPlannerRepository {
  final DailyPlannerRemoteDataSource remoteDataSource;

  DailyPlannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final tasks = await remoteDataSource.getTasks();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> addTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        isCompleted: task.isCompleted,
        time: task.time,
        duration: task.duration,
      );
      final newTask = await remoteDataSource.addTask(taskModel);
      return Right(newTask);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        isCompleted: task.isCompleted,
        time: task.time,
        duration: task.duration,
      );
      final updatedTask = await remoteDataSource.updateTask(taskModel);
      return Right(updatedTask);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
       await remoteDataSource.deleteTask(taskId);
       return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> generateTasksFromPrompt(String prompt) async {
    try {
      final generatedTasks = await remoteDataSource.generateTasksFromPrompt(prompt);
      
      // Optionnel : Sauvegarder automatiquement les tâches générées en base ?
      // Pour l'instant, on les renvoie juste pour que l'UI les affiche.
      // Mais si on veut qu'elles persistent immédiatement :
      final savedTasks = <Task>[];
      for (var taskModel in generatedTasks) {
          try {
             final saved = await remoteDataSource.addTask(taskModel);
             savedTasks.add(saved);
          } catch (e) {
             // Ignorer les erreurs d'ajout individuel (doublons etc)
          }
      }
      
      return Right(savedTasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
