import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../Model/HomeModel/Marks/MarkModel.dart';

class MarksDataSource extends DataGridSource {
  MarksDataSource({required List<MarkModel> marks}) {
    _marksData = marks.map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'student', value: e.studentName),
      DataGridCell<String>(columnName: 'subject', value: e.subjectName),
      DataGridCell<String>(columnName: 'type', value: e.type),
      DataGridCell<String>(columnName: 'teacher', value: e.teacherName),
      DataGridCell<num>(columnName: 'score', value: e.score),
    ])).toList();
  }

  List<DataGridRow> _marksData = [];

  @override
  List<DataGridRow> get rows => _marksData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        String val = e.value.toString();
        if (e.columnName == 'type') val = val.tr;
        
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(val),
        );
      }).toList(),
    );
  }
}