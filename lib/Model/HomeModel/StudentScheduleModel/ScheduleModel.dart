import 'ScheduleSlotModel.dart';

class ScheduleModel {
  final int scheduleId;
  final Map<String, Map<String, ScheduleSlotModel>> days;

  ScheduleModel({required this.scheduleId, required this.days});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final int id = json['schedule_id'] ??
                 (json['schedule'] != null ? json['schedule']['id'] : null) ??
                 json['id'] ?? 
                 (json['data'] is Map ? json['data']['id'] : 0);
    
    final Map<String, Map<String, ScheduleSlotModel>> daysMap = {};
    if (json['data'] != null && json['data'] is List) {
      final List data = json['data'];
      for (var dayData in data) {
        final String dayName = (dayData['day']?.toString() ?? '').toLowerCase().trim();
        if (dayName.isEmpty) continue;
        final List slots = dayData['slots'] as List? ?? [];
        daysMap[dayName] = {};
        for (var slotData in slots) {
          final slot = ScheduleSlotModel.fromJson(slotData);
          if (slot.periodName.isNotEmpty) {
            daysMap[dayName]![slot.periodName] = slot;
          }
        }
      }
    } 
    else if (json['data'] != null && json['data'] is Map) {
      final Map<String, dynamic> data = json['data'];
      data.forEach((dayName, slots) {
        final normalizedDay = dayName.toLowerCase().trim();
        if (slots is List) {
          daysMap[normalizedDay] = {};
          for (var slotData in slots) {
            final slot = ScheduleSlotModel.fromJson(slotData);
            if (slot.periodName.isNotEmpty) {
              daysMap[normalizedDay]![slot.periodName] = slot;
            }
          }
        }
      });
    }

    return ScheduleModel(scheduleId: id, days: daysMap);
  }
}
