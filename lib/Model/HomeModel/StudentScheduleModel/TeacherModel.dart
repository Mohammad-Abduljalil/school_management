class TeacherModel {
  final int id;
  final String full_name;
  final int teacher_id;
  final String imageUrl;

  TeacherModel({
    required this.id,
    required this.full_name,
    required this.teacher_id,
    required this.imageUrl,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('user') && json['user'] is Map) {
      final user = json['user'];
      return TeacherModel(
        id: user['id'] ?? 0,
        full_name: user['full_name'] ?? '',
        teacher_id: json['teacher_id'] ?? 0,
        imageUrl: user['profile_image'] ?? '',
      );
    }
    
    return TeacherModel(
      id: json['id'] ?? 0,
      full_name: json['full_name'] ?? json['name'] ?? '',
      teacher_id: json['teacher_id'] ?? json['id'] ?? 0,
      imageUrl: json['image_url'] ?? '',
    );
  }
}
