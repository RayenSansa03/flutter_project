/// Configuration de l'injection de dépendances (GetIt)
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projet_flutter/core/network/api_client.dart';
import 'package:projet_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:projet_flutter/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:projet_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:projet_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:projet_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:projet_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:projet_flutter/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:projet_flutter/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:projet_flutter/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:projet_flutter/features/auth/domain/usecases/upload_profile_image_usecase.dart';
import 'package:projet_flutter/features/auth/domain/usecases/logout_usecase.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:projet_flutter/features/daily_planner/data/datasources/daily_planner_remote_datasource.dart';
import 'package:projet_flutter/features/daily_planner/data/repositories/daily_planner_repository_impl.dart';
import 'package:projet_flutter/features/daily_planner/domain/repositories/daily_planner_repository.dart';
import 'package:projet_flutter/features/daily_planner/domain/usecases/get_tasks_usecase.dart';
import 'package:projet_flutter/features/daily_planner/domain/usecases/manage_tasks_usecases.dart';
import 'package:projet_flutter/features/daily_planner/presentation/bloc/daily_planner_bloc.dart';
import 'package:projet_flutter/features/focus_session/data/datasources/focus_session_remote_datasource.dart';
import 'package:projet_flutter/features/focus_session/data/repositories/focus_session_repository_impl.dart';
import 'package:projet_flutter/features/focus_session/domain/repositories/focus_session_repository.dart';
import 'package:projet_flutter/features/focus_session/domain/usecases/focus_session_usecases.dart';
import 'package:projet_flutter/features/focus_session/presentation/bloc/focus_session_bloc.dart';

final getIt = GetIt.instance;

/// Initialise toutes les dépendances
Future<void> configureDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Core
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Auth - Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: getIt(),
      sharedPreferences: getIt(),
    ),
  );

  // Auth - Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Auth - Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt()),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt()),
  );

  getIt.registerLazySingleton<VerifyEmailUseCase>(
    () => VerifyEmailUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt()),
  );

  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt()),
  );

  getIt.registerLazySingleton<UploadProfileImageUseCase>(
    () => UploadProfileImageUseCase(getIt()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt()),
  );

  // Auth - BLoC
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt(),
      registerUseCase: getIt(),
      verifyEmailUseCase: getIt(),
      getProfileUseCase: getIt(),
      updateProfileUseCase: getIt(),
      uploadProfileImageUseCase: getIt(),
      logoutUseCase: getIt(),
    ),
  );

  // Daily Planner - Data Sources
  getIt.registerLazySingleton<DailyPlannerRemoteDataSource>(
    () => DailyPlannerRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Daily Planner - Repository
  getIt.registerLazySingleton<DailyPlannerRepository>(
    () => DailyPlannerRepositoryImpl(remoteDataSource: getIt()),
  );

  // Daily Planner - Use Cases
  getIt.registerLazySingleton<GetTasksUseCase>(
    () => GetTasksUseCase(getIt()),
  );

  getIt.registerLazySingleton<AddTaskUseCase>(
    () => AddTaskUseCase(getIt()),
  );

  getIt.registerLazySingleton<UpdateTaskUseCase>(
    () => UpdateTaskUseCase(getIt()),
  );

  getIt.registerLazySingleton<DeleteTaskUseCase>(
    () => DeleteTaskUseCase(getIt()),
  );

  getIt.registerLazySingleton<GenerateTasksUseCase>(
    () => GenerateTasksUseCase(getIt()),
  );

  // Daily Planner - BLoC
  getIt.registerFactory<DailyPlannerBloc>(
    () => DailyPlannerBloc(
      getTasksUseCase: getIt(),
      addTaskUseCase: getIt(),
      updateTaskUseCase: getIt(),
      deleteTaskUseCase: getIt(),
      generateTasksUseCase: getIt(),
    ),
  );
  // Focus Session - Data Sources
  getIt.registerLazySingleton<FocusSessionRemoteDataSource>(
    () => FocusSessionRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Focus Session - Repository
  getIt.registerLazySingleton<FocusSessionRepository>(
    () => FocusSessionRepositoryImpl(remoteDataSource: getIt()),
  );

  // Focus Session - Use Cases
  getIt.registerLazySingleton<GetFocusSessionsUseCase>(
    () => GetFocusSessionsUseCase(getIt()),
  );
  getIt.registerLazySingleton<CreateFocusSessionUseCase>(
    () => CreateFocusSessionUseCase(getIt()),
  );
  getIt.registerLazySingleton<UpdateFocusSessionUseCase>(
    () => UpdateFocusSessionUseCase(getIt()),
  );
  getIt.registerLazySingleton<JoinFocusSessionUseCase>(
    () => JoinFocusSessionUseCase(getIt()),
  );
  getIt.registerLazySingleton<LeaveFocusSessionUseCase>(
    () => LeaveFocusSessionUseCase(getIt()),
  );

  // Focus Session - BLoC
  getIt.registerLazySingleton<FocusSessionBloc>(
    () => FocusSessionBloc(
      getFocusSessionsUseCase: getIt(),
      createFocusSessionUseCase: getIt(),
      updateFocusSessionUseCase: getIt(),
      joinFocusSessionUseCase: getIt(),
      leaveFocusSessionUseCase: getIt(),
    ),
  );
}
