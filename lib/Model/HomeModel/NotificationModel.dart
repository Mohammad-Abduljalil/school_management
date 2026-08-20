class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final String grade;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.grade,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'students',
      grade: json['grade'] ?? 'All Grades',
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
