/// Entité User du domaine
class UserEntity {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? image; // URL Cloudinary de l'image de profil
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });
}
