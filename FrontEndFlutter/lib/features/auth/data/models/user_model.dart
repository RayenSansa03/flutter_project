import 'package:json_annotation/json_annotation.dart';
import 'package:projet_flutter/features/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    super.firstName,
    super.lastName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          createdAt: createdAt ?? DateTime.now(),
          updatedAt: updatedAt ?? DateTime.now(),
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Gérer les cas où createdAt et updatedAt sont absents ou null
    DateTime? createdAt;
    DateTime? updatedAt;
    
    try {
      if (json['createdAt'] != null) {
        createdAt = json['createdAt'] is String
            ? DateTime.parse(json['createdAt'] as String)
            : null;
      }
    } catch (e) {
      createdAt = null;
    }
    
    try {
      if (json['updatedAt'] != null) {
        updatedAt = json['updatedAt'] is String
            ? DateTime.parse(json['updatedAt'] as String)
            : null;
      }
    } catch (e) {
      updatedAt = null;
    }

    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
