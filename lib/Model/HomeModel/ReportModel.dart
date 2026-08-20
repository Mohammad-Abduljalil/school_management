class ReportModel {
  final int id;
  final int? studyStageId;
  final int? sectionId;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String filePath;
  final String? studyStageName;
  final String? sectionName;

  ReportModel({
    required this.id,
    this.studyStageId,
    this.sectionId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.filePath,
    this.studyStageName,
    this.sectionName,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? 0,
      studyStageId: json['study_stage_id'],
      sectionId: json['section_id'],
      type: json['type'] ?? 'General',
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      filePath: json['file_path'] ?? '',
      studyStageName: json['study_stage'] != null ? json['study_stage']['name']?.toString() : null,
      sectionName: json['section'] != null ? json['section']['name']?.toString() : null,
    );
  }
}
