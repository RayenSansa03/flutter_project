import 'package:equatable/equatable.dart';
import 'package:projet_flutter/features/daily_planner/domain/entities/task.dart';

abstract class DailyPlannerEvent extends Equatable {
  const DailyPlannerEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends DailyPlannerEvent {}

class AddTaskEvent extends DailyPlannerEvent {
  final Task task;

  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class ToggleTaskEvent extends DailyPlannerEvent {
  final Task task;

  const ToggleTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class GenerateTasksEvent extends DailyPlannerEvent {
  final String prompt;

  const GenerateTasksEvent(this.prompt);

  @override
  List<Object?> get props => [prompt];
}

class UpdateTaskEvent extends DailyPlannerEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends DailyPlannerEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
