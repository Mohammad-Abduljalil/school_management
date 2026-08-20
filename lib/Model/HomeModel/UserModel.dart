import '../../core/AppConstants.dart';

class UserModel {
  final String id;
  final String full_name;
  final String email;
  final String phone;
  final String role;
  int status;
  final String? profile_image;

  UserModel({
    required this.id,
    required this.full_name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    this.profile_image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? rawImagePath = json['profile_image'];
    String? finalImagePath;

    if (rawImagePath != null) {
      // If the link contains localhost, replace it with the server IP
      finalImagePath = rawImagePath.replaceFirst('http://localhost', AppConstants.linkServer);
    }
    return UserModel(
      id: json['id'].toString(),
      full_name: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'STUDENT',
      status: json['approved'] is int
          ? json['approved']
          : int.tryParse(json['approved'].toString()) ?? 0,
      profile_image: json['profile_image'],
    );
  }
}