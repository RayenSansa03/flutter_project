import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_flutter/features/daily_planner/domain/usecases/get_tasks_usecase.dart';
import 'package:projet_flutter/features/daily_planner/domain/usecases/manage_tasks_usecases.dart';
import 'package:projet_flutter/features/daily_planner/presentation/bloc/daily_planner_event.dart';
import 'package:projet_flutter/features/daily_planner/presentation/bloc/daily_planner_state.dart';

class DailyPlannerBloc extends Bloc<DailyPlannerEvent, DailyPlannerState> {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GenerateTasksUseCase generateTasksUseCase; // Restored

  DailyPlannerBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase, // Injected
    required this.generateTasksUseCase,
  }) : super(DailyPlannerInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<ToggleTaskEvent>(_onToggleTask);
    on<UpdateTaskEvent>(_onUpdateTask); // New handler
    on<DeleteTaskEvent>(_onDeleteTask); // New handler
    on<GenerateTasksEvent>(_onGenerateTasks);
  }

  // ... (keep existing handlers)

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<DailyPlannerState> emit,
  ) async {
    final currentState = state;
    if (currentState is DailyPlannerLoaded) {
      // Optimistic update
      final updatedList = currentState.tasks.map((t) {
        return t.id == event.task.id ? event.task : t;
      }).toList();
      emit(DailyPlannerLoaded(updatedList));

      final result = await updateTaskUseCase(event.task);
      result.fold(
        (failure) {
          emit(DailyPlannerError(failure.message));
          add(LoadTasksEvent());
        },
        (_) {},
      );
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<DailyPlannerState> emit,
  ) async {
    final currentState = state;
    if (currentState is DailyPlannerLoaded) {
      // Optimistic delete
      final updatedList = currentState.tasks.where((t) => t.id != event.taskId).toList();
      emit(DailyPlannerLoaded(updatedList));

      final result = await deleteTaskUseCase(event.taskId);
      result.fold(
        (failure) {
          emit(DailyPlannerError(failure.message));
          add(LoadTasksEvent());
        },
        (_) {},
      );
    }
  }

  // ... (keep _onGenerateTasks and other methods)

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<DailyPlannerState> emit,
  ) async {
    emit(DailyPlannerLoading());
    final result = await getTasksUseCase();
    result.fold(
      (failure) => emit(DailyPlannerError(failure.message)),
      (tasks) => emit(DailyPlannerLoaded(tasks)),
    );
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<DailyPlannerState> emit,
  ) async {
    final currentState = state;
    if (currentState is DailyPlannerLoaded) {
      final result = await addTaskUseCase(event.task);
      result.fold(
        (failure) => emit(DailyPlannerError(failure.message)),
        (newTask) {
          final updatedTasks = List.of(currentState.tasks)..add(newTask);
          emit(DailyPlannerLoaded(updatedTasks));
        },
      );
    }
  }

  Future<void> _onToggleTask(
    ToggleTaskEvent event,
    Emitter<DailyPlannerState> emit,
  ) async {
    final currentState = state;
    if (currentState is DailyPlannerLoaded) {
      final updatedTask = event.task.copyWith(isCompleted: !event.task.isCompleted);
      // Optimistic update
      final updatedList = currentState.tasks.map((t) {
        return t.id == updatedTask.id ? updatedTask : t;
      }).toList();
      emit(DailyPlannerLoaded(updatedList));

      final result = await updateTaskUseCase(updatedTask);
      result.fold(
        (failure) {
          // Revert on failure
          emit(DailyPlannerError(failure.message));
          add(LoadTasksEvent());
        },
        (_) {}, // Success, already updated
      );
    }
  }

  Future<void> _onGenerateTasks(
    GenerateTasksEvent event,
    Emitter<DailyPlannerState> emit,
  ) async {
    emit(DailyPlannerLoading());
    final result = await generateTasksUseCase(event.prompt);
    result.fold(
      (failure) => emit(DailyPlannerError(failure.message)),
      (newTasks) {
         // Reload to get full list (mocked logic appends to list)
         add(LoadTasksEvent());
      },
    );
  }
}
