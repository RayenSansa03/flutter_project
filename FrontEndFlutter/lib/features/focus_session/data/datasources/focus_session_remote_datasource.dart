import 'package:projet_flutter/core/network/api_client.dart';
import 'package:projet_flutter/features/focus_session/data/models/focus_session_model.dart';
import 'package:projet_flutter/core/errors/exceptions.dart';
import 'package:dio/dio.dart';

abstract class FocusSessionRemoteDataSource {
  Future<List<FocusSessionModel>> getSessions();
  Future<FocusSessionModel> createSession(FocusSessionModel session, List<String>? invitedUserIds);
  Future<FocusSessionModel> updateSession(String id, Map<String, dynamic> data);
  Future<FocusSessionModel> joinSession(String id);
  Future<void> leaveSession(String id);
  Future<void> deleteSession(String id);
}

class FocusSessionRemoteDataSourceImpl implements FocusSessionRemoteDataSource {
  final ApiClient apiClient;

  FocusSessionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<FocusSessionModel>> getSessions() async {
    try {
      final response = await apiClient.get('/sessions');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => FocusSessionModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Failed to load sessions');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<FocusSessionModel> createSession(FocusSessionModel session, List<String>? invitedUserIds) async {
    try {
      final data = session.toJson();
      if (invitedUserIds != null) {
        data['invitedUserIds'] = invitedUserIds;
      }
      
      final response = await apiClient.post('/sessions', data: data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return FocusSessionModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to create session');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<FocusSessionModel> updateSession(String id, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.put('/sessions/$id', data: data);
      if (response.statusCode == 200) {
        return FocusSessionModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to update session');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<FocusSessionModel> joinSession(String id) async {
    try {
      final response = await apiClient.post('/sessions/$id/join');
      if (response.statusCode == 201 || response.statusCode == 200) {
        return FocusSessionModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to join session');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<void> leaveSession(String id) async {
    try {
      await apiClient.delete('/sessions/$id/leave');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<void> deleteSession(String id) async {
    try {
      await apiClient.delete('/sessions/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
