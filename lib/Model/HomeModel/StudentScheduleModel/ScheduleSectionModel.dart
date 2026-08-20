class ScheduleSectionModel {
  final int sectionId;
  final String sectionName;

  ScheduleSectionModel({required this.sectionId, required this.sectionName});

  factory ScheduleSectionModel.fromJson(int id, String name) {
    return ScheduleSectionModel(
      sectionId: id,
      sectionName: "Section $name",
    );
  }
}
