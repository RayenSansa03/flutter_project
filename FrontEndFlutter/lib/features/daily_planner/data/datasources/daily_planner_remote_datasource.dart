import 'package:dio/dio.dart';
import 'package:projet_flutter/core/config/app_config.dart';
import 'package:projet_flutter/core/errors/exceptions.dart';
import 'package:projet_flutter/features/daily_planner/data/models/task_model.dart';
import 'package:projet_flutter/core/network/api_client.dart';

abstract class DailyPlannerRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> addTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<List<TaskModel>> generateTasksFromPrompt(String prompt);
}

class DailyPlannerRemoteDataSourceImpl implements DailyPlannerRemoteDataSource {
  final ApiClient apiClient;

  DailyPlannerRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await apiClient.get('/tasks');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => TaskModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Erreur serveur: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      throw ServerException('Erreur (get) [$status]: $data');
    }
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    try {
      final response = await apiClient.post('/tasks', data: task.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      } else {
        throw ServerException('Erreur lors de l\'ajout: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      throw ServerException('Erreur (add) [$status]: $data');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await apiClient.put('/tasks/${task.id}', data: task.toJson());
      if (response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      } else {
        throw ServerException('Erreur lors de la mise à jour: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      throw ServerException('Erreur (update) [$status]: $data');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final response = await apiClient.delete('/tasks/$taskId');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException('Erreur lors de la suppression: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      throw ServerException('Erreur (delete) [$status]: $data');
    }
  }

  @override
  Future<List<TaskModel>> generateTasksFromPrompt(String prompt) async {
    try {
      // Use full URL to override base URL of ApiClient for RAG
      final response = await apiClient.post(
        '${AppConfig.ragBaseUrl}/generate-plan',
        data: {'prompt': prompt}, 
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('tasks')) {
          return (data['tasks'] as List)
              .map((json) => TaskModel.fromJson(json))
              .toList();
        } else if (data is List) {
           return data.map((json) => TaskModel.fromJson(json)).toList();
        }
        return [];
      } else {
        throw ServerException('Erreur serveur RAG: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      throw ServerException('Erreur RAG [$status]: $data');
    } catch (e) {
      throw ServerException('Erreur inattendue RAG: $e');
    }
  }
}
