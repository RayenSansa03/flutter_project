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
  getIt.registerFactory<AuthBloc>(
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
}
