import '../SectionModel.dart';

class StageModel {
  final int id;
  final int stage_number;
  final List<int> section_number;
  final List<SectionModel> sections;

  StageModel({
    required this.id,
    required this.stage_number,
    required this.section_number,
    required this.sections,
  });

  factory StageModel.fromJson(Map<String, dynamic> json) {
    var rawSections = json['section_number'];
    List<int> parsedSectionNumbers = [];
    List<SectionModel> parsedSections = [];

    if (rawSections is Map) {
      rawSections.forEach((key, value) {
        int? sNumber = int.tryParse(key.toString());
        int? sId = value is int ? value : int.tryParse(value.toString());
        
        if (sNumber != null) {
          parsedSectionNumbers.add(sNumber);
        }
        
        if (sId != null) {
          parsedSections.add(SectionModel(
            id: sId,
            name: "Section $key",
            gradeId: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
          ));
        }
      });
    } else if (rawSections is List) {
      for (int i = 0; i < rawSections.length; i++) {
        var val = rawSections[i];
        if (val != null) {
          int sId = val is int ? val : int.tryParse(val.toString()) ?? 0;
          parsedSectionNumbers.add(i + 1);
          parsedSections.add(SectionModel(
            id: sId,
            name: "Section ${i + 1}",
            gradeId: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
          ));
        }
      }
    }

    return StageModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      stage_number: json['stage_number'] is int ? json['stage_number'] : int.tryParse(json['stage_number']?.toString() ?? '0') ?? 0,
      section_number: parsedSectionNumbers,
      sections: parsedSections,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stage_number': stage_number,
      'section_number': section_number,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StageModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
