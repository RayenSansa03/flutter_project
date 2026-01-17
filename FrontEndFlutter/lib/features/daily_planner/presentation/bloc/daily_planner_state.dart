import 'package:equatable/equatable.dart';
import 'package:projet_flutter/features/daily_planner/domain/entities/task.dart';

abstract class DailyPlannerState extends Equatable {
  const DailyPlannerState();

  @override
  List<Object?> get props => [];
}

class DailyPlannerInitial extends DailyPlannerState {}

class DailyPlannerLoading extends DailyPlannerState {}

class DailyPlannerLoaded extends DailyPlannerState {
  final List<Task> tasks;

  const DailyPlannerLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class DailyPlannerError extends DailyPlannerState {
  final String message;

  const DailyPlannerError(this.message);

  @override
  List<Object?> get props => [message];
}
