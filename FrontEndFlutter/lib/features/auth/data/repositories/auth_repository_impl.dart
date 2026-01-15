import 'package:dartz/dartz.dart';
import 'package:projet_flutter/core/errors/exceptions.dart';
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:projet_flutter/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:projet_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:projet_flutter/features/auth/domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final authResponse = await remoteDataSource.login(email, password);
      
      // Sauvegarder le token et l'utilisateur localement
      await localDataSource.saveToken(authResponse.accessToken);
      await localDataSource.saveUser(authResponse.user);

      return Right(authResponse.user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final registerResponse = await remoteDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      
      // Retourner le tempToken pour la vérification email
      return Right(registerResponse.tempToken);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyEmail(String tempToken, String code) async {
    try {
      final authResponse = await remoteDataSource.verifyEmail(tempToken, code);
      
      // Sauvegarder le token et l'utilisateur localement
      await localDataSource.saveToken(authResponse.accessToken);
      await localDataSource.saveUser(authResponse.user);

      return Right(authResponse.user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final user = await remoteDataSource.getProfile();
      await localDataSource.saveUser(user);
      return Right(user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({String? firstName, String? lastName}) async {
    try {
      final user = await remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
      );
      await localDataSource.saveUser(user);
      return Right(user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> uploadProfileImage(String imagePath) async {
    try {
      final user = await remoteDataSource.uploadProfileImage(imagePath);
      await localDataSource.saveUser(user);
      return Right(user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      await localDataSource.deleteUser();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la déconnexion: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la vérification: ${e.toString()}'));
    }
  }
}
