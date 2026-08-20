class PeriodTemplateModel {
  final int id;
  final String name;
  final String startTime;
  final String endTime;

  PeriodTemplateModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory PeriodTemplateModel.fromJson(Map<String, dynamic> json) {
    return PeriodTemplateModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
    );
  }
}
