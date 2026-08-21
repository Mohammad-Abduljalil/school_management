class NotificationModel {
  final int id;
  final String title;
  final String body; // Maps to 'content' from backend
  final String type; // Maps to 'type' or defaults
  final String? grade;
  final int? studentId; // Maps to 'student_id' from backend
  final bool isRead;
  final DateTime createdAt; // Maps to 'sent_at' from backend

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.grade,
    this.studentId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '') ?? 0),
      title: json['title'] ?? '',
      body: json['content'] ?? '', // Backend uses 'content'
      type: json['type'] ?? 'students',
      grade: json['grade'],
      studentId: json['student_id'] is int ? json['student_id'] : int.tryParse(json['student_id']?.toString() ?? ''),
      isRead: json['is_read'] is bool ? json['is_read'] : (json['is_read']?.toString() == '1'),
      createdAt: json['sent_at'] != null 
          ? (DateTime.tryParse(json['sent_at']) ?? DateTime.now()) 
          : DateTime.now(), // Backend uses 'sent_at'
    );
  }
}
