import 'package:dio/dio.dart';
import 'package:projet_flutter/core/network/api_client.dart';
import 'package:projet_flutter/core/network/api_response.dart';
import 'package:projet_flutter/core/errors/exceptions.dart';
import 'package:projet_flutter/features/auth/data/models/auth_response_model.dart';
import 'package:projet_flutter/features/auth/data/models/register_response_model.dart';
import 'package:projet_flutter/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<RegisterResponseModel> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });
  Future<AuthResponseModel> verifyEmail(String tempToken, String code);
  Future<UserModel> getProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data == null) {
        throw ServerException('Réponse invalide du serveur');
      }

      // Le backend retourne directement { success, data, message } ou { access_token, user }
      // Vérifier le format de la réponse
      final data = response.data!;
      
      // Si la réponse contient directement access_token, c'est le format du backend
      if (data.containsKey('access_token')) {
        return AuthResponseModel.fromJson(data);
      }
      
      // Sinon, c'est le format ApiResponse
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message ?? 'Erreur lors de la connexion');
      }

      return AuthResponseModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Email ou mot de passe incorrect');
      }
      throw ServerException('Erreur lors de la connexion: ${e.message}');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Erreur inattendue: ${e.toString()}');
    }
  }

  @override
  Future<RegisterResponseModel> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
        },
      );

      if (response.data == null) {
        throw ServerException('Réponse invalide du serveur');
      }

      final data = response.data!;
      
      // Le backend retourne maintenant { message, tempToken }
      return RegisterResponseModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw ValidationException('Un utilisateur avec cet email existe déjà');
      }
      
      // Extraire le message d'erreur du serveur si disponible
      String errorMessage = 'Erreur lors de l\'inscription';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          errorMessage = data['message'] ?? data['error'] ?? errorMessage;
        } else if (data is String) {
          errorMessage = data;
        }
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      
      throw ServerException(errorMessage);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Erreur inattendue: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponseModel> verifyEmail(String tempToken, String code) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        '/auth/verify-email',
        data: {
          'tempToken': tempToken,
          'code': code,
        },
      );

      if (response.data == null) {
        throw ServerException('Réponse invalide du serveur');
      }

      final data = response.data!;
      
      // Si la réponse contient directement access_token, c'est le format du backend
      if (data.containsKey('access_token')) {
        return AuthResponseModel.fromJson(data);
      }
      
      // Sinon, c'est le format ApiResponse
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message ?? 'Erreur lors de la vérification');
      }

      return AuthResponseModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Code incorrect ou token expiré');
      }
      throw ServerException('Erreur lors de la vérification: ${e.message}');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Erreur inattendue: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>('/auth/profile');

      if (response.data == null) {
        throw ServerException('Réponse invalide du serveur');
      }

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data!,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message ?? 'Erreur lors de la récupération du profil');
      }

      return UserModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Non autorisé');
      }
      throw ServerException('Erreur lors de la récupération du profil: ${e.message}');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Erreur inattendue: ${e.toString()}');
    }
  }
}
