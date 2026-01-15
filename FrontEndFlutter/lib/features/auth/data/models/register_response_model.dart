import 'package:json_annotation/json_annotation.dart';

part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel {
  final String message;
  final String tempToken;

  RegisterResponseModel({
    required this.message,
    required this.tempToken,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: json['message'] as String,
      tempToken: json['tempToken'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
}
