class SectionModel {
  final int id;
  final String name;
  final int? gradeId;

  SectionModel({required this.id, required this.name, this.gradeId});

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      gradeId: json['grade_id'] ?? json['study_stage_id'],
    );
  }
}
