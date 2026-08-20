import 'ScheduleSectionModel.dart';

class ScheduleStageModel {
  final int id;
  final int stageNumber;
  final List<ScheduleSectionModel> sections;
  ScheduleStageModel({
    required this.id,
    required this.stageNumber,
    required this.sections,
  });

  factory ScheduleStageModel.fromJson(Map<String, dynamic> json) {
    var sectionsMap = json['section_number'];
    List<ScheduleSectionModel> parsedSections = [];
    
    if (sectionsMap is Map) {
      sectionsMap.forEach((key, value) {
        if (value != null) {
          parsedSections.add(ScheduleSectionModel.fromJson(
            value is int ? value : int.tryParse(value.toString()) ?? 0, 
            key.toString()
          ));
        }
      });
    } else if (sectionsMap is List) {
      for (int i = 0; i < sectionsMap.length; i++) {
        var val = sectionsMap[i];
        if (val != null) {
          parsedSections.add(ScheduleSectionModel.fromJson(
            val is int ? val : int.tryParse(val.toString()) ?? 0, 
            (i+1).toString()
          ));
        }
      }
    }

    return ScheduleStageModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      stageNumber: json['stage_number'] is int ? json['stage_number'] : int.tryParse(json['stage_number']?.toString() ?? '0') ?? 0,
      sections: parsedSections,
    );
  }
}
