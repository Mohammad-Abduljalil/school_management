class MarkModel {
  final int id;
  final String studentName;
  final String teacherName;
  final String subjectName;
  final String type;
  final num score;
  final String date;

  MarkModel({
    required this.id,
    required this.studentName,
    required this.teacherName,
    required this.subjectName,
    required this.type,
    required this.score,
    required this.date,
  });

  factory MarkModel.fromJson(Map<String, dynamic> json) {
    return MarkModel(
      id: json['id'] ?? 0,
      score: json['score'] ?? 0,
      type: json['type'] ?? '',
      studentName: json['student']?['user']?['name'] ?? 'Unknown',
      teacherName: json['teacher']?['user']?['name'] ?? 'Unknown',
      subjectName: json['material']?['name'] ?? 'Unknown',
      date: json['created_at'] ?? '',
    );
  }
}