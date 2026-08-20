class SubjectModel {
  final int id;
  final String name;
  final int? gradeId;

  SubjectModel({required this.id, required this.name, this.gradeId});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      gradeId: json['grade_id'] ?? json['study_stage_id'],
    );
  }
}
