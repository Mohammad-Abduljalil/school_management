class ScheduleSlotModel {
  final int id;
  final String periodName;
  final String startTime;
  final String endTime;
  final String materialName;
  final String teacherName;
  int materialId;
  int teacherId;
  int periodId;

  ScheduleSlotModel({
    required this.id,
    required this.periodName,
    required this.startTime,
    required this.endTime,
    required this.materialName,
    required this.teacherName,
    this.materialId = 0,
    this.teacherId = 0,
    this.periodId = 0,
  });

  factory ScheduleSlotModel.fromJson(Map<String, dynamic> json) {
    int mId = 0;
    if (json['material_id'] != null) {
      mId = json['material_id'] is int ? json['material_id'] : int.tryParse(json['material_id'].toString()) ?? 0;
    } else if (json['material'] is Map && json['material']['id'] != null) {
      mId = json['material']['id'] is int ? json['material']['id'] : int.tryParse(json['material']['id'].toString()) ?? 0;
    }

    int tId = 0;
    if (json['teacher_id'] != null) {
      tId = json['teacher_id'] is int ? json['teacher_id'] : int.tryParse(json['teacher_id'].toString()) ?? 0;
    } else if (json['teacher'] is Map && json['teacher']['teacher_id'] != null) {
      tId = json['teacher']['teacher_id'] is int ? json['teacher']['teacher_id'] : int.tryParse(json['teacher']['teacher_id'].toString()) ?? 0;
    }

    return ScheduleSlotModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      periodName: json['period']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      materialName: json['material'] is Map ? (json['material']['name'] ?? '') : (json['material']?.toString() ?? ''),
      teacherName: json['teacher'] is Map ? (json['teacher']['user']?['full_name'] ?? json['teacher']['full_name'] ?? '') : (json['teacher']?.toString() ?? ''),
      
      materialId: mId,
      teacherId: tId,
      periodId: json['period_id'] is int ? json['period_id'] : int.tryParse(json['period_id']?.toString() ?? '0') ?? 0,
    );
  }
}
