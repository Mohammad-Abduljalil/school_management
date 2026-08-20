class SalaryModel {
  final int id;
  final String name;final String email;
  final String phone;
  final String salary;
  int status;
  final String role;
  final String? personalImage;

  SalaryModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.salary,
    required this.status,
    required this.role,
    this.personalImage,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    final firstUserLevel = json['user'];
    final profile = firstUserLevel != null ? firstUserLevel['user'] : null;

    return SalaryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: profile?['full_name'] ?? 'Unknown',
      email: profile?['email'] ?? 'No Email',
      phone: profile?['phone'] ?? 'No Phone',
      salary: json['salary']?.toString() ?? '0',
      status: json['paid'] is int ? json['paid'] : int.tryParse(json['paid']?.toString() ?? '0') ?? 0,
      role: json['employeeable_type'] ?? 'Teacher',
      personalImage: profile?['profile_image'],
    );
  }
}